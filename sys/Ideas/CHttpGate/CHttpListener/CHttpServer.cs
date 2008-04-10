using System;
using System.Threading;
using System.IO;
using System.Net;
using System.Text;
using System.Collections.Generic;

namespace CHttpListener
{
    public abstract class CHttpHandler
    {
        abstract public bool ProcessRequest(CHttpRequest arequest);
    }

    public class CHttpRequest
    {
        private HttpListenerContext context;
        private string requestId;
        private CHttpSession session = null;
        private CHttpServer server = null;
        public void SendServerOverloaded(CHttpRequest arequest)
        {
            CHttpResponse response = new CHttpTextResponse("Sever overloaded");
            response.SendResponse(HttpStatusCode.ServiceUnavailable, arequest);
        }
        public void SendServerExpired(CHttpRequest arequest)
        {
            CHttpResponse response = new CHttpTextResponse("Session expired");
            response.SendResponse(HttpStatusCode.Forbidden, arequest);
        }
        public void SendServerError(CHttpRequest arequest)
        {
            CHttpResponse response = new CHttpTextResponse("Server error");
            response.SendResponse(HttpStatusCode.InternalServerError, arequest);
        }
        public CHttpRequest(CHttpServer aserver, HttpListenerContext acontext)
        {
            context = acontext;
            requestId = context.Request.RequestTraceIdentifier.ToString("N");
            server = aserver;
        }
        public string RequestId { get { return requestId; } }
        public HttpListenerRequest Request { get { return context.Request; } }
        public HttpListenerResponse Response { get { return context.Response; } }
        public CHttpSession Session { get { return session; } set { session = value; } }
        public CHttpServer Server { get { return server; } }
        public HttpListenerContext Context { get { return context; } }
    }

    public abstract class CHttpResponse
    {
        public abstract bool SendResponse(HttpStatusCode acode, CHttpRequest arequest);
    }

    public class CHttpTextResponse : CHttpResponse
    {
        private string text = "";
        public CHttpTextResponse(string atext)
        {
            text = atext;
        }
        public override bool SendResponse(HttpStatusCode acode, CHttpRequest arequest)
        {
            bool result = false;
            arequest.Response.StatusCode = (int)acode;
            try
            {
                StreamWriter writer = new StreamWriter(arequest.Response.OutputStream);
                writer.WriteLine(text);
                writer.Close();
            }
            finally
            {
                try
                {
                    arequest.Response.Close();
                    result = true;
                }
                catch (Exception e)
                {
                    arequest.Server.ServerLog.LogWarn("Got close response error " + e.Message + " for request " + arequest.RequestId);
                }
            }
            return result;
        }
    }

    public class CHttpFileResponse : CHttpResponse
    {
        private string fileName = "";
        public CHttpFileResponse(string afileName)
        {
            fileName = afileName;
        }
        public override bool SendResponse(HttpStatusCode acode, CHttpRequest arequest)
        {
            bool result = false;
            arequest.Response.StatusCode = (int)acode;
            if (File.Exists(fileName))
            {
                try
                {
                    FileStream fileStream = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                    BinaryReader responseReader = new BinaryReader(fileStream);
                    long bytesLeft = fileStream.Length;
                    byte[] byteBuffer = new byte[8192];
                    bool finished = false;
                    int bytesRead;
                    try
                    {
                        while ((!finished) && (arequest.Server.IsRunning))
                        {
                            bytesRead = responseReader.Read(byteBuffer, 0, 8192);
                            if (bytesRead > 0)
                            {
                                try
                                {
                                    arequest.Response.OutputStream.Write(byteBuffer, 0, bytesRead);
                                }
                                catch (Exception e)
                                {
                                    finished = true;
                                    arequest.Server.ServerLog.LogWarn("Got response write error " + e.Message + " for request " + arequest.RequestId);
                                }
                            }
                            else
                            {
                                finished = true;
                            }
                        }
                    }
                    finally
                    {
                        fileStream.Close();
                        try
                        {
                            arequest.Response.Close();
                            result = true;
                        }
                        catch (Exception e)
                        {
                            arequest.Server.ServerLog.LogWarn("Got close response error " + e.Message + " for request " + arequest.RequestId);
                        }
                    }
                }
                catch (Exception e)
                {
                    arequest.Server.ServerLog.LogWarn("Got processing error " + e.Message + " for request " + arequest.RequestId);
                }
            }
            return result;
        }
    }

    public class CHttpSession
    {
        private string sessionId = null;
        private DateTime touchTime;
        private bool isUsed = false;
        public string SessionId { get { return sessionId; } }
        public DateTime TouchTime
        {
            get
            {
                DateTime result;
                Monitor.Enter(this);
                try
                {
                    result = touchTime;
                }
                finally
                {
                    Monitor.Exit(this);
                }
                return result;
            }
            set
            {
                Monitor.Enter(this);
                try
                {
                    touchTime = value;
                }
                finally
                {
                    Monitor.Exit(this);
                }
            }
        }
        public bool IsUsed
        {
            get
            {
                bool result;
                Monitor.Enter(this);
                try
                {
                    result = isUsed;
                }
                finally
                {
                    Monitor.Exit(this);
                }
                return result;
            }
            set
            {
                Monitor.Enter(this);
                try
                {
                    isUsed = value;
                }
                finally
                {
                    Monitor.Exit(this);
                }
            }
        }
        public CHttpSession(bool aisUsed)
        {
            sessionId = System.Guid.NewGuid().ToString("N");
            touchTime = DateTime.Now;
            isUsed = aisUsed;
        }
    }

    public class CHttpSessions
    {
        private ManualResetEvent haltEvent = new ManualResetEvent(true);
        private ManualResetEvent checkStartedEvent = new ManualResetEvent(false);
        private ManualResetEvent checkFinishedEvent = new ManualResetEvent(true);
        private Mutex lockMutex = new Mutex();
        private Thread expiredThread = null;
        private List<CHttpSession> list = new List<CHttpSession>();
        private int checkExpiredPeriod = 10000;
        private int forceExpiredTimeout = 2000;
        private int expirationTime = 10000;
        private int getSessionRepeats = 3;
        private int getSessionTimeout = 1000;
        private CHttpServer parentServer = null;
        private void CheckExpired()
        {
            bool haltPending = false;
            while (!haltPending)
            {
                if (!haltEvent.WaitOne(checkExpiredPeriod, false))
                {
                    if (lockMutex.WaitOne(forceExpiredTimeout, false))
                    {
                        try
                        {
                            for (int counter = list.Count - 1; counter >= 0; --counter)
                            {
                                CHttpSession session = list[counter];
                                if (session.TouchTime.AddMilliseconds(expirationTime) <= DateTime.Now)
                                {
                                    parentServer.ServerLog.LogInfo("Removing expired session " + session.SessionId);
                                    list.RemoveAt(counter);
                                }
                            }
                        }
                        finally
                        {
                            checkFinishedEvent.Set();
                            checkStartedEvent.Reset();
                            lockMutex.ReleaseMutex();
                        }
                    }
                    else
                    {
                        checkFinishedEvent.Reset();
                        checkStartedEvent.Set();
                    }
                }
                else
                {
                    haltPending = true;
                }
            }
        }
        public CHttpSession GetSession(string asessionId)
        {
            CHttpSession result = null;
            int repeats = 0;
            int waitResult = 0;
            bool alreadyChecked = false;
            bool running = !haltEvent.WaitOne(0, false);
            WaitHandle[] listLocks = new WaitHandle[] { lockMutex, haltEvent, checkStartedEvent };
            WaitHandle[] flushLocks = new WaitHandle[] { haltEvent, checkFinishedEvent };
            while (running && (repeats <= getSessionRepeats) && (result == null) && !alreadyChecked)
            {
                waitResult = WaitHandle.WaitAny(listLocks, getSessionTimeout, false);
                if (waitResult == 0)
                {
                    try
                    {
                        if (asessionId == "")
                        {
                            result = new CHttpSession(true);
                            result.IsUsed = true;
                            list.Add(result);
                        }
                        else
                        {
                            result = list.Find(session => session.SessionId == asessionId);
                            if (result != null)
                            {
                                if ((result.TouchTime.AddMilliseconds(expirationTime) <= DateTime.Now) && !result.IsUsed)
                                {
                                    parentServer.ServerLog.LogInfo("Removing expired session " + result.SessionId);
                                    list.Remove(result);
                                    result = null;
                                }
                                else
                                {
                                    result.IsUsed = true;
                                }
                            }
                        }
                        alreadyChecked = true;
                    }
                    finally
                    {
                        lockMutex.ReleaseMutex();
                    }
                }
                else if (waitResult == 2)
                {
                    WaitHandle.WaitAny(flushLocks, 5000, false);
                }
                repeats++;
                running = !haltEvent.WaitOne(0, false);
            }
            return result;
        }
        public void InitializeSessions(CHttpServer aserver)
        {
            parentServer = aserver;
            haltEvent.Reset();
            expiredThread = new Thread(new ThreadStart(CheckExpired));
            expiredThread.Start();
        }
        public void FinalizeSessions()
        {
            haltEvent.Set();
            expiredThread.Join();
        }
    }

    public class CHttpServer
    {
        #region zmienne prywatne
        private ManualResetEvent serverHaltEvent = null;
        private HttpListener serverListener = null;
        private Thread serverThread = null;
        private CHttpLog serverLog = null;
        private AuthenticationSchemes authenticationScheme = AuthenticationSchemes.Anonymous;
        private Type[] handlerTypes = null;
        private CHttpSessions serverSessions = new CHttpSessions();
        #endregion

        #region zmienne publiczne
        public CHttpLog ServerLog { get { return serverLog; } }
        public CHttpSessions ServerSessions { get { return serverSessions; } }
        public bool IsRunning { get { return !serverHaltEvent.WaitOne(0, false); } }
        #endregion

        #region obsługa zgłoszeń
        private object CreateHandler(Type atype)
        {
            return Activator.CreateInstance(atype);
        }
        private void ProcessRequest(Object stateInfo)
        {
            CHttpRequest request = (CHttpRequest)stateInfo;
            bool processed = false;
            int counter = 0;
            try
            {
                while ((!processed) && (counter <= handlerTypes.Length - 1))
                {
                    CHttpHandler handler = (CHttpHandler)CreateHandler(handlerTypes[counter]);
                    processed = handler.ProcessRequest(request);
                    if (processed)
                    {
                        serverLog.LogInfo("Request " + request.RequestId + " HTTP " + request.Request.HttpMethod + " " + request.Request.Url + " was handled by " + handler.ToString());
                    }
                    counter++;
                }
                if (!processed)
                {
                    CHttpResponse response = new CHttpTextResponse("Sorry, request not handled");
                    response.SendResponse(HttpStatusCode.OK, request);
                    serverLog.LogWarn("Request " + request.RequestId + " was not handled by any handler");
                }
            }
            catch (Exception e)
            {
                serverLog.LogError("Got error while processing " + request.RequestId + " " + e.Message);
                request.SendServerError(request);
            }
        }
        #endregion

        #region metody wątków
        private void AcceptNewClient(IAsyncResult iar)
        {
            if (serverListener.IsListening)
            {
                try
                {
                    HttpListenerContext context = serverListener.EndGetContext(iar);
                    CHttpRequest request = new CHttpRequest(this, context);
                    try
                    {
                        ThreadPool.QueueUserWorkItem(new WaitCallback(ProcessRequest), request);
                    }
                    catch (Exception e)
                    {
                        serverLog.LogError("Cant queue request " + context.Request.RequestTraceIdentifier.ToString("N") + " " + e.Message);
                        request.SendServerOverloaded(request);
                    }
                }
                catch (Exception e)
                {
                    serverLog.LogError("Accept client error " + e.Message);
                }
            }
        }
        private void Listen()
        {
            bool shutdownPending = false;
            while (!shutdownPending)
            {
                IAsyncResult iar = serverListener.BeginGetContext(new AsyncCallback(AcceptNewClient), this);
                WaitHandle[] waitEvents = new WaitHandle[] {iar.AsyncWaitHandle, serverHaltEvent };
                if (WaitHandle.WaitAny(waitEvents) == 1)
                {
                    shutdownPending = true;
                    serverListener.Close();
                }
            }
        }
        #endregion

        #region metody publiczne
        public void StartServer(string[] acceptPrefixes)
        {
            serverHaltEvent = new ManualResetEvent(false);
            serverListener = new HttpListener();
            serverListener.AuthenticationSchemes = authenticationScheme;
            serverLog.LogInfo("Initializing server");
            serverLog.LogInfo("Adding prefixes");
            foreach (string pref in acceptPrefixes) 
            {
                try
                {
                    serverListener.Prefixes.Add(pref);
                    serverLog.LogInfo("   " + pref);
                }
                catch (Exception)
                {
                    serverLog.LogInfo("   " + pref + " is invalid, ignored");
                }
            }
            serverLog.LogInfo("Initializing sessions");
            serverSessions.InitializeSessions(this);
            serverLog.LogInfo("Initializing listener");
            serverListener.Start();
            serverThread = new Thread(new ThreadStart(Listen));
            serverThread.Start();
            serverLog.LogInfo("Server running");
        }
        public void StopServer()
        {
            serverLog.LogInfo("Attempting to stop server");
            serverHaltEvent.Set();
            serverLog.LogInfo("Waiting for server thread to finish");
            serverThread.Join();
            serverLog.LogInfo("Closing listener");
            serverListener.Close();
            serverLog.LogInfo("Finalizing sessions");
            serverSessions.FinalizeSessions();
            serverLog.LogInfo("Server halted");
        }
        public CHttpServer(CHttpLog alog, AuthenticationSchemes ascheme, Type[] ahandlerTypes)
        {
            serverLog = alog;
            authenticationScheme = ascheme;
            handlerTypes = ahandlerTypes;
        }
        #endregion
    }
}
