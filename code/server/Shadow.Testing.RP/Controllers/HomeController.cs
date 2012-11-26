using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.Messaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Mvc;

namespace Shadow.Testing.RP.Controllers
{
  public class HomeController : Controller
  {
    public ActionResult Index()
    {
      return View();
    }

    [HttpPost]
    public ActionResult Index(string provider)
    {
      using (OpenIdRelyingParty openid = new OpenIdRelyingParty())
      {
        IAuthenticationRequest request = openid.CreateRequest(provider);

        // Send your visitor to their Provider for authentication.
        return request.RedirectingResponse.AsActionResult();
      }
    }
  }
}
