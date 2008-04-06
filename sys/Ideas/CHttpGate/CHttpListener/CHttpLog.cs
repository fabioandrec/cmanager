using System;
using System.Collections;
using System.Net;
using System.Threading;
using System.Text;

namespace CHttpListener
{

    #region bazowe klasy logWriter
    public interface ICHttpLogWriter
    {
        void WriteToLog(string ainformation);
        void InitializeWriter();
        void FinalizeWriter();
    }

    public class CHttpConsoleLogWriter : ICHttpLogWriter
    {
        public void WriteToLog(string ainformation)
        {
            Console.WriteLine(ainformation);
        }
        public void InitializeWriter()
        {    
        }
        public void FinalizeWriter()
        {
        }
    }
    #endregion

    #region klasy log
    public enum HttpLogLevel { LogNone = 4, LogError = 3, LogWarning = 2, LogInfo = 1 };

    public class CHttpLogItem
    {
        private HttpLogLevel level;
        private string information;
        public CHttpLogItem(HttpLogLevel alevel, string ainformation)
        {
            level = alevel;
            information = ainformation;
        }
        public HttpLogLevel Level 
        {
            get 
            {
                return level;
            }
        }
        public string Information
        {
            get 
            {
                return information;
            }
        }
    }

    public class CHttpLog
    {
        #region właściwości prywatne
        private HttpLogLevel logLevel = HttpLogLevel.LogInfo;
        private Queue logQueue = new Queue();
        private int logTimeout = 1000;
        private int logRepeats = 3;
        private int logFlushCount = 1;
        private int logFlushTime = 100;
        private int forceFlushTimeout = 100;
        private ICHttpLogWriter logWriter = null;
        private Thread writerThread = null;
        private bool isRunning = false;
        private Mutex queueMutex = new Mutex();
        private ManualResetEvent stopEvent = new ManualResetEvent(true);
        private ManualResetEvent runEvent = new ManualResetEvent(false);
        private ManualResetEvent flushStartedEvent = new ManualResetEvent(false);
        private ManualResetEvent flushFinishedEvent = new ManualResetEvent(true);
        private ManualResetEvent queueEvent = new ManualResetEvent(false);
        #endregion

        #region metody prywatne
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
        private void WriteToLog()
        {
            WaitHandle[] queueEvents = new WaitHandle[] {queueEvent, stopEvent};
            WaitHandle[] queueLocks = new WaitHandle[] { queueMutex, stopEvent };
            bool haltPending = false;
            int waitResult;
            while (!haltPending) 
            {
                waitResult = WaitHandle.WaitAny(queueEvents, logFlushTime, false);
                if (waitResult == 0)
                {
                    if (queueMutex.WaitOne(forceFlushTimeout, false))
                    {
                        try
                        {
                            while (logQueue.Count != 0)
                            {
                                CHttpLogItem item = (CHttpLogItem)logQueue.Dequeue();
                                logWriter.WriteToLog(item.Information);
                            }
                        }
                        finally
                        {
                            if (logQueue.Count == 0)
                            {
                                queueEvent.Reset();
                            }
                            flushStartedEvent.Reset();
                            flushFinishedEvent.Set();
                            queueMutex.ReleaseMutex();
                        }
                    }
                    else
                    {
                        flushFinishedEvent.Reset();
                        flushStartedEvent.Set();
                    }
                }
                else
                {
                    haltPending = (waitResult == 1);
                }
            }
        }
        #endregion

        #region metody uruchamiające i zatrzymujące logowanie
        public bool StartLog()
        {
            if (!isRunning)
            {
                logWriter.InitializeWriter();
                stopEvent.Reset();
                runEvent.Set();
                writerThread = new Thread(new ThreadStart(WriteToLog));
                writerThread.Start();
                isRunning = true;
            }
            return isRunning;
        }
        public bool StopLog()
        {
            if (isRunning)
            {
                runEvent.Reset();
                stopEvent.Set();
                writerThread.Join();
                logWriter.FinalizeWriter();
                isRunning = false;
            }
            return !isRunning;
        }
        public CHttpLog(ICHttpLogWriter writer, HttpLogLevel alevel)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer cannot be null");
            }
            logWriter = writer;
            logLevel = alevel;
        }
        #endregion

        #region metody logujące
        public bool LogText(string ainformation, bool awithPrefix, HttpLogLevel alevel)
        {
            string information = ainformation;
            bool queued = false;
            if (awithPrefix)
            {
                information = LogPrefix(alevel) + " " + information;
            }
            if (alevel >= logLevel)
            {
                int repeats = 0;
                int waitResult = 0;
                bool running = runEvent.WaitOne(0, false);
                WaitHandle[] queueLocks = new WaitHandle[] { queueMutex, stopEvent, flushStartedEvent };
                WaitHandle[] flushLocks = new WaitHandle[] { stopEvent, flushFinishedEvent };
                while (running && (repeats <= logRepeats) && !queued)
                {
                    waitResult = WaitHandle.WaitAny(queueLocks, logTimeout, false);
                    if (waitResult == 0)
                    {
                        try
                        {
                            logQueue.Enqueue(new CHttpLogItem(alevel, information));
                            queued = true;
                        }
                        finally
                        {
                            if (logQueue.Count >= logFlushCount)
                            {
                                queueEvent.Set();
                            }
                            queueMutex.ReleaseMutex();
                        }
                    }
                    else if (waitResult == 2)
                    {
                        WaitHandle.WaitAny(flushLocks, 5000, false);
                    }
                    repeats++;
                    running = runEvent.WaitOne(0, false) && !stopEvent.WaitOne(0, false);
                }
            }
            return queued;
        }
        public bool LogInfo(string ainformation)
        {
            return LogText(ainformation, true, HttpLogLevel.LogInfo);
        }
        public bool LogInfo(string ainformation, bool awithPrefix)
        {
            return LogText(ainformation, awithPrefix, HttpLogLevel.LogInfo);
        }
        public bool LogWarn(string ainformation)
        {
            return LogText(ainformation, true, HttpLogLevel.LogWarning);
        }
        public bool LogWarn(string ainformation, bool awithPrefix)
        {
            return LogText(ainformation, awithPrefix, HttpLogLevel.LogWarning);
        }
        public bool LogError(string ainformation)
        {
            return LogText(ainformation, true, HttpLogLevel.LogError);
        }
        public bool LogError(string ainformation, bool awithPrefix)
        {
            return LogText(ainformation, awithPrefix, HttpLogLevel.LogError);
        }
        #endregion
    }
    #endregion

}
