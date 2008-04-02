using System;
using System.Collections.Generic;
using System.Text;
using CHttpListener;

namespace CHttpGateConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            IHttpLog httpLog = new CHttpLogConsole();
            CHttpServer httpServer = new CHttpServer("d:\\http", httpLog, HttpLogLevel.LogInfo);
            httpServer.StartServer(new string[1] { "http://*:8080/" });
            Console.ReadLine();
            httpServer.StopServer();
        }
    }
}
