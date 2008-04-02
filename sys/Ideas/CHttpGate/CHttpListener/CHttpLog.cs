using System;
using System.Collections.Generic;
using System.Net;
using System.Threading;
using System.Text;

namespace CHttpListener
{
    public enum HttpLogLevel {LogNone = 4, LogError = 3, LogWarning = 2, LogInfo = 1};

    public interface IHttpLog
    {
        void LogText(HttpLogLevel level, string text);
        void LogRequest(HttpLogLevel level, HttpListenerRequest request);
    }

    public class CHttpLogConsole : IHttpLog
    {
        private string LogPrefix(HttpLogLevel level)
        {
            DateTime now = DateTime.Now;
            string levelText;
            string threadId = Thread.CurrentThread.ManagedThreadId.ToString();
            switch (level)
            {
                case HttpLogLevel.LogError:
                    levelText = "-";
                    break;
                case HttpLogLevel.LogWarning:
                    levelText = "!";
                    break;
                default:
                    levelText = " ";
                    break;
            }
            return levelText + now.ToShortDateString() + " " + now.ToShortTimeString() + " " + threadId ;
        }
        public void LogText(HttpLogLevel level, string text)
        {
            Console.WriteLine(LogPrefix(level) + " " +  text);
        }
        public void LogRequest(HttpLogLevel level, HttpListenerRequest request)
        {
            string requestText = String.Format("[{0}] {1} HTTP {2} {3}", request.RemoteEndPoint.Address.ToString(), request.HttpMethod, request.ProtocolVersion, request.RawUrl);
            Console.WriteLine(LogPrefix(level) + " " + requestText);
        }
    }
}
