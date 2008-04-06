using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Net;
using CHttpListener;

namespace CHttpListener
{
    public class CHttpBasicHandler : CHttpHandler
    {
        private static string rootDirectory = "";
        public static string RootDirectory { get { return rootDirectory; } set { rootDirectory = value.TrimEnd('\\'); } }
        public override bool ProcessRequest(CHttpServer aserver, CHttpRequest arequest)
        {
            if (arequest.Request.HttpMethod.ToUpper() == "GET")
            {
                string fileName = rootDirectory + arequest.Request.Url.LocalPath.Replace("/", "\\");
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
                            while ((!finished) && (aserver.IsRunning))
                            {
                                bytesRead = responseReader.Read(byteBuffer, 0, 8192);
                                if (bytesRead > 0)
                                {
                                    try
                                    {
                                        arequest.Response.OutputStream.Write(byteBuffer, 0, bytesRead);
                                    }
                                    catch (Exception e)
                                    {
                                        finished = true;
                                        aserver.ServerLog.LogWarn("Got response write error " + e.Message + " for request " + arequest.ContextId);
                                    }
                                }
                                else
                                {
                                    finished = true;
                                }
                            }
                            aserver.ServerLog.LogInfo(String.Format("{0} {1} HTTP {2}", arequest.ContextId, arequest.Request.HttpMethod, arequest.Request.Url));
                            return true;
                        }
                        finally
                        {
                            fileStream.Close();
                            try
                            {
                                arequest.Response.Close();
                            }
                            catch (Exception e)
                            {
                                aserver.ServerLog.LogWarn("Got close response error " + e.Message + " for request " + arequest.ContextId);
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        aserver.ServerLog.LogWarn("Got processing error " + e.Message + " for request " + arequest.ContextId);
                    }

                }
            }
            return false;
        }
    }
}
