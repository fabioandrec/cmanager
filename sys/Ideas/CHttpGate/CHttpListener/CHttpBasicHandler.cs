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
        public override bool ProcessRequest(CHttpRequest arequest)
        {
            if (arequest.Request.HttpMethod.ToUpper() == "GET")
            {
                string fileName = rootDirectory + arequest.Request.Url.LocalPath.Replace("/", "\\");
                CHttpFileResponse response = new CHttpFileResponse(fileName);
                return response.SendResponse(HttpStatusCode.OK, arequest);
            }
            else
            {
                return false;
            }
        }
    }
}
