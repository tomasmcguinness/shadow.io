using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
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

      var content = message.Content.ReadAsStringAsync().Result;

      rep.SaveMessage(new Shadow.UShadow.Data.Message() { Body = content });

      return new HttpResponseMessage(HttpStatusCode.OK);
    }

    public void Put(string target, string message)
    {

    }

    public HttpResponseMessage Get()
    {
      MessageRepository rep = new MessageRepository();
      List<UShadow.Models.Message> messages = new List<Models.Message>();

      foreach (var message in rep.Get())
      {
        messages.Add(new Models.Message() { Body = message.Body });
      }

      return new HttpResponseMessage(HttpStatusCode.OK)
      {
        Content = new ObjectContent<ICollection<UShadow.Models.Message>>(messages, new JsonMediaTypeFormatter())
      };
    }
  }
}
