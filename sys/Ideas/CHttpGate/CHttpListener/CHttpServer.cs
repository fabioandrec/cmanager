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
        abstract public bool ProcessRequest(CHttpServer aserver, CHttpRequest arequest);
    }

    public class CHttpRequest
    {
        private HttpListenerContext context;
        private string requestId;
        public void SendServerOverloaded()
        {
            throw new NotImplementedException();
        }
        public void SendServerError()
        {
            throw new NotImplementedException();
        }
        public CHttpRequest(HttpListenerContext acontext)
        {
            context = acontext;
            requestId = context.Request.RequestTraceIdentifier.ToString("N");
        }
        public string RequestId { get { return requestId; } }
        public HttpListenerRequest Request { get { return context.Request; } }
        public HttpListenerResponse Response { get { return context.Response; } }
    }

    public class CHttpSession
    {
        private string sessionId = null;
        private DateTime touchTime;
        public string SessionId { get { return sessionId; } }
        public DateTime TouchTime { get { return touchTime; } }
        public CHttpSession()
        {
            sessionId = System.Guid.NewGuid().ToString("N");
            touchTime = DateTime.Now;
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
        private int checkExpiredPeriod = 2000;
        private int forceExpiredTimeout = 2000;
        private int expirationTime = 5000;
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
                                if (session.TouchTime.AddMilliseconds(expirationTime) >= DateTime.Now)
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
                    processed = handler.ProcessRequest(this, request);
                    counter++;
                }
            }
            catch (Exception e)
            {
                serverLog.LogError("Got error while processing " + request.RequestId + " " + e.Message);
                request.SendServerError();
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
                    CHttpRequest request = new CHttpRequest(context);
                    try
                    {
                        ThreadPool.QueueUserWorkItem(new WaitCallback(ProcessRequest), request);
                    }
                    catch (Exception e)
                    {
                        serverLog.LogError("Cant queue request " + context.Request.RequestTraceIdentifier.ToString("N") + " " + e.Message);
                        request.SendServerOverloaded();
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
