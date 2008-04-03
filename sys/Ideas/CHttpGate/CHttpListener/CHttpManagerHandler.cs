using System;
using System.Text;
using System.Collections;
using System.Collections.Specialized;
using System.Net;
using System.Threading;
using CHttpListener;


namespace CHttpListener
{
    class CHttpManagerSession
    {
    }

    public class CHttpManagerHandler : ICHttpRequestHandler
    {
        private Hashtable sessions;
        public bool ProcessHttpRequest(CHttpServer server, HttpListenerContext context)
        {
            HttpListenerRequest req = context.Request;
            string reqId = req.RequestTraceIdentifier.ToString("N");
            HttpListenerResponse res = context.Response;
            if (req.HttpMethod.ToUpper() == "GET")
            {
                if (req.Url.PathAndQuery == "/")
                {
                    if (context.Request.Cookies.Count == 0)
                    {
                        Guid sessionId = System.Guid.NewGuid();
                        context.Response.Cookies.Add(new Cookie("sessionId", sessionId.ToString("N")));
                        server.LogText(HttpLogLevel.LogInfo, "Request " + reqId + " new sessionId " + sessionId.ToString("N"));
                    }
                    server.SendTextResponse(context, HttpStatusCode.OK, "Witamy");
                    return true;
                }
            }
            return false;
        }
        public CHttpManagerHandler()
        {
            sessions = Hashtable.Synchronized(new Hashtable());
        }
    }
}
