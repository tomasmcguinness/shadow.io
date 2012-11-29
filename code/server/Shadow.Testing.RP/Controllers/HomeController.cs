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
      using (OpenIdRelyingParty openid = new OpenIdRelyingParty())
      {
        var response = openid.GetResponse();

        if (response != null)
        {
          switch (response.Status)
          {
            case AuthenticationStatus.Authenticated:
              ViewData["Authenticated"] = "TRUE";
              break;
            case AuthenticationStatus.Canceled:
              //this.loginCanceledLabel.Visible = true;
              break;
            case AuthenticationStatus.Failed:
              //this.loginFailedLabel.Visible = true;
              break;
          }
        }
      }

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
