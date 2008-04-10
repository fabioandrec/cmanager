using System;
using System.Text;
using System.Collections;
using System.Collections.Specialized;
using System.Net;
using System.Threading;
using CHttpListener;


namespace CHttpListener
{
    public class CHttpManagerHandler : CHttpHandler
    {

        public override bool ProcessRequest(CHttpRequest arequest)
        {
            Uri reqUri = arequest.Request.Url;
            if (reqUri.PathAndQuery.StartsWith("/cmanager?"))
            {
                if (ValidateSession(arequest))
                {
                    return true;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return false;
            }
        }

        private bool ValidateSession(CHttpRequest arequest)
        {
            Cookie sessionCookie = arequest.Request.Cookies["sessionId"];
            CHttpSession sessionObject = null;
            if ((sessionCookie == null) || ((sessionCookie != null) && (sessionCookie.Value == "")))
            {
                sessionObject = arequest.Server.ServerSessions.GetSession("");
                arequest.Response.Cookies.Add(new Cookie("sessionId", sessionObject.SessionId));
            }
            else
            {
                sessionObject = arequest.Server.ServerSessions.GetSession(sessionCookie.Value);                
            }
            if (sessionObject != null)
            {
                try
                {
                    sessionObject.TouchTime = DateTime.Now;
                    arequest.Session = sessionObject;
                    CHttpResponse response = new CHttpTextResponse("Hello with session id " + sessionObject.SessionId + " touchTime " + sessionObject.TouchTime.ToString());
                    response.SendResponse(HttpStatusCode.OK, arequest);
                }
                finally
                {
                    arequest.Session.IsUsed = false;
                }
            }
            else
            {
                arequest.Response.Cookies.Add(new Cookie("sessionId", ""));
                arequest.SendServerExpired(arequest);
            }
            return true;
        }
    }    
}
