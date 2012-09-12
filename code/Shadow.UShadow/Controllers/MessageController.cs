using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Shadow.UShadow.Data;
using Shadow.UShadow.Models;

namespace Shadow.UShadow.Controllers
{
  public class MessageController : ApiController
  {
    public HttpResponseMessage Post(HttpRequestMessage message)
    {
      // Record the message and inform the user.
      //
      MessageRepository rep = new MessageRepository();

      //string body = message.Content as StringContent;

      //rep.SaveMessage(new Shadow.UShadow.Data.Message() { Body = body });

      return new HttpResponseMessage(HttpStatusCode.OK);
    }

    public void Put(string target, string message)
    {


    }

    public ICollection<Shadow.UShadow.Models.Message> Get()
    {
      return null;
    }
  }
}
