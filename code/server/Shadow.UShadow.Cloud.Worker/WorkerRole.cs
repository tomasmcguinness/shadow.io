using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Threading;
using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.Diagnostics;
using Microsoft.WindowsAzure.ServiceRuntime;
using Microsoft.WindowsAzure.StorageClient;

namespace Shadow.UShadow.Cloud.Worker
{
    public class WorkerRole : RoleEntryPoint
    {
        public override void Run()
        {
            // This is a sample worker implementation. Replace with your logic.
            Trace.WriteLine("Shadow.UShadow.Cloud.Worker entry point called", "Information");

            // Connect to Twitter.
            //
            Stream.ProcessTweetDelegate produceTweetDelegate = new Stream.ProcessTweetDelegate(processTweet);

            // Creating the stream and specifying the delegate
            Stream myStream = new Stream(produceTweetDelegate);

            Token token = new Token()
            {
                AccessToken = "14910567-1AnQzrOuwPFsPd9HrcXrCPBmW7Cwf7doxXqd5vdgi",
                AccessTokenSecret = "hHzkPdejgaJkt9VKxW7JGDC0AnJ5GzvlRjhNaHzYzW4",
                ConsumerKey = "WFYdWcCCTZk4ASituGqhqQ",
                ConsumerSecret = "DfOmNZOrhN31vuEDpm10lxkSSB1MfjVA4Y9oPzSK0gc"
            };

            myStream.StreamUrl = "https://userstream.twitter.com/1.1/user.json?with=user&track=!Shadow";

            // Starting the stream by specifying credentials thanks to the Token
            myStream.StartStream(token);

            while (true)
            {
                Thread.Sleep(10000);
                Trace.WriteLine("Working", "Information");
            }
        }

        private void processTweet(Tweet tweet, bool force)
        {
            if (tweet != null)
            {
                Trace.WriteLine(tweet.text, "Information");
            }
        }

        public override bool OnStart()
        {
            // Set the maximum number of concurrent connections 
            ServicePointManager.DefaultConnectionLimit = 12;

            // For information on handling configuration changes
            // see the MSDN topic at http://go.microsoft.com/fwlink/?LinkId=166357.

            return base.OnStart();
        }
    }
}
