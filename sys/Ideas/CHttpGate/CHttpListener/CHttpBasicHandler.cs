using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Net;
using CHttpListener;

namespace CHttpListener
{
    public class CHttpBasicHandler : ICHttpRequestHandler
    {
        private string rootDirectory = "";
        public bool ProcessHttpRequest(CHttpServer server, HttpListenerContext context)
        {
            HttpListenerRequest req = context.Request;
            HttpListenerResponse res = context.Response;
            if (req.HttpMethod.ToUpper() == "GET")
            {
                string fileName = rootDirectory + req.Url.LocalPath.Replace("/", "\\");
                if (File.Exists(fileName))
                {
                    try
                    {
                        FileStream fileStream = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                        BinaryReader responseReader = new BinaryReader(fileStream);
                        long bytesLeft = fileStream.Length;
                        byte[] byteBuffer = new byte[8192];
                        bool finished = false;
                        int bytesRead;
                        try
                        {
                            while (!finished)
                            {
                                bytesRead = responseReader.Read(byteBuffer, 0, 8192);
                                if (bytesRead > 0)
                                {
                                    try
                                    {
                                        res.OutputStream.Write(byteBuffer, 0, bytesRead);
                                    }
                                    catch (Exception e)
                                    {
                                        finished = true;
                                        server.LogText(HttpLogLevel.LogWarning, this.ToString() + " request " + req.RequestTraceIdentifier.ToString("N") + " response write error " + e.Message);
                                    }
                                }
                                else
                                {
                                    finished = true;
                                }
                            }
                            return true;
                        }
                        finally
                        {
                            fileStream.Close();
                            res.Close();
                        }
                    }
                    catch (Exception e)
                    {
                        server.LogText(HttpLogLevel.LogWarning, this.ToString() + " request " + req.RequestTraceIdentifier.ToString("N") + " processing error " + e.Message);
                    }

                }
            }
            return false;
        }
        public CHttpBasicHandler(string root)
        {
            rootDirectory = root.TrimEnd('\\');
        }
    }
}
