using System;
using System.Collections.Generic;
using System.Net;
using System.Threading;
using System.Text;

namespace CHttpListener
{
    public enum HttpLogLevel {LogNone = 4, LogError = 3, LogWarning = 2, LogInfo = 1};

    public interface ICHttpLog
    {
        void LogText(HttpLogLevel level, string text);
        void LogRequest(HttpLogLevel level, HttpListenerRequest request);
    }

    public class CHttpLogConsole : ICHttpLog
    {
        private HttpLogLevel logLevel = HttpLogLevel.LogInfo;
        private string LogPrefix(HttpLogLevel level)
        {
            DateTime now = DateTime.Now;
            string levelText;
            string threadId = Thread.CurrentThread.ManagedThreadId.ToString("X").PadLeft(6, '0');
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
            return levelText + now.ToShortDateString() + " " + now.ToShortTimeString() + " " + threadId;
        }
        public void LogText(HttpLogLevel level, string text)
        {
            if (level >= logLevel)
            {
                Console.WriteLine(LogPrefix(level) + " " + text);
            }
        }
        public void LogRequest(HttpLogLevel level, HttpListenerRequest request)
        {
            if (level >= logLevel)
            {
                string requestText = String.Format("Request {0} {1} {2} HTTP {3} {4}", request.RequestTraceIdentifier.ToString("N"), request.RemoteEndPoint.Address.ToString(), request.HttpMethod, request.ProtocolVersion, request.RawUrl);
                Console.WriteLine(LogPrefix(level) + " " + requestText);
            }
        }
        public CHttpLogConsole(HttpLogLevel level)
        {
            logLevel = level;
        }
    }
}
