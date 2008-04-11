using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
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
            CHttpBasicHandler.RootDirectory = Directory.GetCurrentDirectory();
            CHttpServer httpServer = new CHttpServer(log, 
                AuthenticationSchemes.Anonymous,
                new Type[] { typeof(CHttpBasicHandler), 
                             typeof(CHttpManagerHandler) });
            httpServer.StartServer(new string[1] { "http://*:8080/" });
            Console.ReadLine();
            httpServer.StopServer();
            log.LogInfo("Log finished");
            log.StopLog();
            Console.ReadLine();
        }
    }
}
