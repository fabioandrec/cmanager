using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Threading;
using CHttpListener;

namespace CHttpGateConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            ICHttpLogWriter logWriter = new CHttpConsoleLogWriter();
            CHttpLog log = new CHttpLog(logWriter, HttpLogLevel.LogInfo);
            log.StartLog();
            log.LogInfo("Log initialized");
            CHttpServer httpServer = new CHttpServer(log, 
                AuthenticationSchemes.Anonymous,
                new Type[] { typeof(CHttpManagerHandler), typeof(CHttpBasicHandler) });
            httpServer.StartServer(new string[1] { "http://*:8080/" });
            Console.ReadLine();
            httpServer.StopServer();
            log.LogInfo("Log finished");
            log.StopLog();
            Console.ReadLine();
        }
    }
}
