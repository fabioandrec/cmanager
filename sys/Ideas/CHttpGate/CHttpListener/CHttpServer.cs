using System;
using System.Threading;
using System.IO;
using System.Net;
using System.Text;

namespace CHttpListener
{
    public interface ICHttpRequestHandler
    {
        bool ProcessHttpRequest(CHttpServer server, HttpListenerContext context);
    }

    public class CHttpServer
    {
        #region zmienne prywatne
        private ManualResetEvent serverHaltEvent = null;
        private HttpListener serverListener = null;
        private Thread serverThread = null;
        private bool isRunning = false;
        private ICHttpLog serverLog = null;
        private ICHttpRequestHandler[] httpHandlers = null;
        private AuthenticationSchemes authenticationScheme;
        #endregion

        #region metody logujące
        public void LogText(HttpLogLevel level, string text)
        {
            if (serverLog != null)
            {
                serverLog.LogText(level, text);
            }
        }
        public void LogRequest(HttpLogLevel level, HttpListenerRequest request)
        {
            if (serverLog != null)
            {
                serverLog.LogRequest(level, request);
            }
        }
        #endregion

        #region obsługa zgłoszeń
        private void ProcessRequest(Object stateInfo)
        {
            bool processed = false;
            HttpListenerContext context = (HttpListenerContext)stateInfo;
            string reqId = context.Request.RequestTraceIdentifier.ToString("N");
            try
            {
                if (httpHandlers != null)
                {
                    int currentHandlerIndex = 0;
                    while ((!processed) && (currentHandlerIndex <= httpHandlers.Length - 1))
                    {
                        processed = httpHandlers[currentHandlerIndex].ProcessHttpRequest(this, context);
                        currentHandlerIndex++;
                    }
                }
            }
            catch (Exception e)
            {
                LogText(HttpLogLevel.LogWarning, "Cant handle request " + reqId + " " + e.Message);
            }
            finally
            {
                if (!processed)
                {
                    LogText(HttpLogLevel.LogWarning, "Request " + reqId + " was not handled by any handler");
                    SendTextResponse((HttpListenerContext)stateInfo, HttpStatusCode.BadRequest, "Bad request");
                }
            }
        }
        private void SendTextResponse(HttpListenerContext context, HttpStatusCode statusCode, string responseText)
        {
            HttpListenerRequest request = context.Request;
            HttpListenerResponse response = context.Response;
            byte[] responseBuffer = System.Text.Encoding.UTF8.GetBytes(responseText);
            response.ContentLength64 = responseBuffer.Length;
            response.StatusCode = (int)statusCode;
            System.IO.Stream responseStream = response.OutputStream;
            responseStream.Write(responseBuffer, 0, responseBuffer.Length);
            responseStream.Close();
        }
        private void SendServiceUnavailable(HttpListenerContext context)
        {
            SendTextResponse(context, HttpStatusCode.ServiceUnavailable, "Service unavailable");
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
                    string reqId = context.Request.RequestTraceIdentifier.ToString("N");
                    LogRequest(HttpLogLevel.LogInfo, context.Request);
                    try
                    {
                        ThreadPool.QueueUserWorkItem(new WaitCallback(ProcessRequest), context);
                    }
                    catch (Exception e)
                    {
                        LogText(HttpLogLevel.LogWarning, "Cant queue request " + reqId + " " + e.Message);
                        SendServiceUnavailable(context);
                    }
                }
                catch (Exception e)
                {
                    LogText(HttpLogLevel.LogWarning, "Cant get request context " + e.Message);
                }
            }
        }
        private void Listen()
        {
            bool shutdownPending = false;
            int waitIndex = -1;
            while (!shutdownPending)
            {
                IAsyncResult iar = serverListener.BeginGetContext(new AsyncCallback(AcceptNewClient), this);
                WaitHandle[] waitEvents = new WaitHandle[] {iar.AsyncWaitHandle, serverHaltEvent };
                waitIndex = WaitHandle.WaitAny(waitEvents);
                if (waitIndex == 1)
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
            LogText(HttpLogLevel.LogInfo, "Starting server...");
            LogText(HttpLogLevel.LogInfo, "Adding prefixes...");
            foreach (string pref in acceptPrefixes) 
            {
                try
                {
                    serverListener.Prefixes.Add(pref);
                    LogText(HttpLogLevel.LogInfo, "   " + pref);
                }
                catch (Exception)
                {
                    LogText(HttpLogLevel.LogWarning, "   " + pref + " is invalid, ignored");
                }
            }
            LogText(HttpLogLevel.LogInfo, "Starting listener...");
            serverListener.Start();
            serverThread = new Thread(new ThreadStart(Listen));
            serverThread.Start();
            isRunning = true;
            LogText(HttpLogLevel.LogInfo, "Server started.");
        }
        public void StopServer()
        {
            LogText(HttpLogLevel.LogInfo, "Attempting to stop server...");
            serverHaltEvent.Set();
            LogText(HttpLogLevel.LogInfo, "Waiting for server thread to finish...");
            serverThread.Join();
            LogText(HttpLogLevel.LogInfo, "Stopping listener...");
            serverListener.Close();
            isRunning = false;
            LogText(HttpLogLevel.LogInfo, "Server stopped.");
        }
        public CHttpServer(ICHttpLog log, AuthenticationSchemes scheme, ICHttpRequestHandler[] handlers)
        {
            serverLog = log;
            authenticationScheme = scheme;
            httpHandlers = handlers;
        }
        #endregion

        #region właściwości publiczne
        public bool IsRunning 
        {
            get
            {
                return isRunning;
            }
        }
        #endregion
    }
}
