using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Web.Http;
using Shadow.UShadow.Models;

namespace Shadow.UShadow.Controllers
{
  public class RootController : ApiController
  {
    public HttpResponseMessage Head()
    {
      return new HttpResponseMessage(HttpStatusCode.OK)
      {
        Content = new ObjectContent(typeof(ShadowProfile),new ShadowProfile() { Owner = "Tomas McGuinness" },new JsonMediaTypeFormatter())
      };
    }

    public ShadowProfile Get()
    {
      return new ShadowProfile() { Owner = "Tomas McGuinness" };
    }
  }
}
