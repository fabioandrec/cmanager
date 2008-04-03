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
            ICHttpLog httpLog = new CHttpLogConsole(HttpLogLevel.LogInfo);
            CHttpServer httpServer = new CHttpServer(httpLog, AuthenticationSchemes.Anonymous, new ICHttpRequestHandler[] {new CHttpBasicHandler("d:\\http\\")});
            httpServer.StartServer(new string[1] { "http://*:8080/" });
            Console.ReadLine();
            httpServer.StopServer();
        }
    }
}
