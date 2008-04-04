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
        static private CHttpLog logServer;
        static void Dowork()
        {
            while (Thread.CurrentThread.IsAlive)
            {
                if (!logServer.LogText("+", false, HttpLogLevel.LogInfo))
                {
                    Console.Write("-");
                }
                Thread.Sleep(1);
            }
        }
        static void Main(string[] args)
        {
            /*
            ICHttpLog httpLog = new CHttpLogConsole(HttpLogLevel.LogInfo);
            CHttpServer httpServer = new CHttpServer(httpLog, AuthenticationSchemes.Anonymous, 
                                                     new ICHttpRequestHandler[] 
                                                     {
                                                         new CHttpBasicHandler("d:\\http\\"),
                                                         new CHttpManagerHandler()
                                                     });
            httpServer.StartServer(new string[1] { "http://*:8080/" });
            Console.ReadLine();
            httpServer.StopServer();
            */
            CHttpConsoleLogWriter logWriter = new CHttpConsoleLogWriter();
            logServer = new CHttpLog(logWriter, HttpLogLevel.LogInfo);
            logServer.StartLog();
            List<Thread> list = new List<Thread> { };
            for (int counter = 0; counter < 2; counter++)
            {
                list.Add(new Thread(new ThreadStart(Dowork)));
                list[counter].Start();
            }
            Console.ReadLine();
            logServer.StopLog();
            for (int counter = 0; counter < list.Count - 1; counter++)
            {
                list[counter].Abort();
            }
        }
    }
}
