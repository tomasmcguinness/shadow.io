using DotNetOpenAuth.OpenId.Extensions.ProviderAuthenticationPolicy;
using DotNetOpenAuth.OpenId.Extensions.SimpleRegistration;
using DotNetOpenAuth.OpenId.Provider;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.Messaging;
using DotNetOpenAuth.OpenId;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;
using Shadow.UShadow.Models;

namespace Shadow.UShadow.Controllers
{
  public class OpenIdController : Controller
  {
    internal static OpenIdProvider openIdProvider = new OpenIdProvider();

    [OutputCache(Duration = 0)]
    public ActionResult Index()
    {
      if (Request.AcceptTypes.Contains("application/xrds+xml"))
      {
        Response.Clear();
        Response.ClearHeaders();
        Response.ContentType = "application/xrds+xml";
        ViewData["OPIdentifier"] = true;
        return View("xrds");
      }

      return View();
    }

    [OutputCache(Duration = 0)]
    public ActionResult XRDS()
    {
      Response.ClearHeaders();
      Response.Clear();
      Response.ContentType = "application/xrds+xml";
      ViewData["OPIdentifier"] = true;
      return View();
    }

    [HttpPost]
    public JsonResult CheckForAuthorization(Guid sessionId)
    {
      AuthenticationModel model = new AuthenticationModel();

      var authorized = model.HasBeenAuthorized(sessionId);

      if (authorized)
      {
        ActionResult result = SendAssertion();
        return result;
      }

      return Json(authorized);
    }

    [ValidateInput(false)]
    public ActionResult Provider()
    {
      IRequest request = openIdProvider.GetRequest();
      if (request != null)
      {
        // Some requests are automatically handled by DotNetOpenAuth.  If this is one, go ahead and let it go.
        if (request.IsResponseReady)
        {
          return openIdProvider.PrepareResponse(request).AsActionResult();
        }

        // This is apparently one that the host (the web site itself) has to respond to.
        ProviderEndpoint.PendingRequest = (IHostProcessedRequest)request;

        // If PAPE requires that the user has logged in recently, we may be required to challenge the user to log in.
        var papeRequest = ProviderEndpoint.PendingRequest.GetExtension<PolicyRequest>();
        if (papeRequest != null && papeRequest.MaximumAuthenticationAge.HasValue)
        {
          //TimeSpan timeSinceLogin = DateTime.UtcNow -  this.FormsAuth.SignedInTimestampUtc.Value;
          //if (timeSinceLogin > papeRequest.MaximumAuthenticationAge.Value)
          {
            // The RP wants the user to have logged in more recently than he has.  
            // We'll have to redirect the user to a login screen.
            return this.RedirectToAction("LogOn", "Account", new { returnUrl = this.Url.Action("ProcessAuthRequest") });
          }

          return RedirectToAction("LogOn", "Account");
        }

        return this.ProcessAuthRequest();
      }
      else
      {
        // No OpenID request was recognized.  This may be a user that stumbled on the OP Endpoint.  
        return this.View();
      }
    }

    public ActionResult ProcessAuthRequest()
    {
      if (ProviderEndpoint.PendingRequest == null)
      {
        return this.RedirectToAction("Index", "Home");
      }

      // Try responding immediately if possible.
      ActionResult response;
      if (this.AutoRespondIfPossible(out response))
      {
        return response;
      }

      // We can't respond immediately with a positive result.  But if we still have to respond immediately...
      if (ProviderEndpoint.PendingRequest.Immediate)
      {
        // We can't stop to prompt the user -- we must just return a negative response.
        return this.SendAssertion();
      }

      return this.RedirectToAction("AskUser");
    }

    /// <summary>
    /// Displays a confirmation page.
    /// </summary>
    /// <returns>The response for the user agent.</returns>
    //[Authorize]
    public ActionResult AskUser()
    {
      if (ProviderEndpoint.PendingRequest == null)
      {
        // Oops... precious little we can confirm without a pending OpenID request.
        return this.RedirectToAction("Index", "Home");
      }

      // The user MAY have just logged in.  Try again to respond automatically to the RP if appropriate.
      ActionResult response;

      if (this.AutoRespondIfPossible(out response))
      {
        return response;
      }

      if (!ProviderEndpoint.PendingAuthenticationRequest.IsDirectedIdentity) // && !this.UserControlsIdentifier(ProviderEndpoint.PendingAuthenticationRequest))
      {
        return this.Redirect(this.Url.Action("LogOn", "Account", new { returnUrl = this.Request.Url }));
      }

      this.ViewData["Realm"] = ProviderEndpoint.PendingRequest.Realm;

      AuthenticationModel authModel = new AuthenticationModel();
      Guid key = authModel.RegisterAuthenticationRequest(ProviderEndpoint.PendingRequest.Realm, this.Request.UserHostAddress);

      return this.View(key);
    }

    [HttpPost, Authorize, ValidateAntiForgeryToken]
    public ActionResult AskUserResponse(bool confirmed)
    {
      if (!ProviderEndpoint.PendingAuthenticationRequest.IsDirectedIdentity) // && !this.UserControlsIdentifier(ProviderEndpoint.PendingAuthenticationRequest))
      {
        // The user shouldn't have gotten this far without controlling the identifier we'd send an assertion for.
        return new HttpStatusCodeResult((int)HttpStatusCode.BadRequest);
      }

      if (ProviderEndpoint.PendingAnonymousRequest != null)
      {
        ProviderEndpoint.PendingAnonymousRequest.IsApproved = confirmed;
      }
      else if (ProviderEndpoint.PendingAuthenticationRequest != null)
      {
        ProviderEndpoint.PendingAuthenticationRequest.IsAuthenticated = confirmed;
      }
      else
      {
        throw new InvalidOperationException("There's no pending authentication request!");
      }

      return this.SendAssertion();
    }

    /// <summary>
    /// Attempts to formulate an automatic response to the RP if the user's profile allows it.
    /// </summary>
    /// <param name="response">Receives the ActionResult for the caller to return, or <c>null</c> if no automatic response can be made.</param>
    /// <returns>A value indicating whether an automatic response is possible.</returns>
    private bool AutoRespondIfPossible(out ActionResult response)
    {
      // If the odds are good we can respond to this one immediately (without prompting the user)...
      if (ProviderEndpoint.PendingRequest.IsReturnUrlDiscoverable(openIdProvider.Channel.WebRequestHandler) == RelyingPartyDiscoveryResult.Success)
      {
        //// Is this is an identity authentication request? (as opposed to an anonymous request)...
        //if (ProviderEndpoint.PendingAuthenticationRequest != null)
        //{
        //  // If this is directed identity, or if the claimed identifier being checked is controlled by the current user...
        //  if (ProviderEndpoint.PendingAuthenticationRequest.IsDirectedIdentity
        //    || this.UserControlsIdentifier(ProviderEndpoint.PendingAuthenticationRequest))
        //  {
        //    ProviderEndpoint.PendingAuthenticationRequest.IsAuthenticated = true;
        //    response = this.SendAssertion();
        //    return true;
        //  }
        //}

        //// If this is an anonymous request, we can respond to that too.
        //if (ProviderEndpoint.PendingAnonymousRequest != null)
        //{
        //  ProviderEndpoint.PendingAnonymousRequest.IsApproved = true;
        //  response = this.SendAssertion();
        //  return true;
        //}
      }

      response = null;
      return false;
    }

    /// <summary>
    /// Sends a positive or a negative assertion, based on how the pending request is currently marked.
    /// </summary>
    /// <returns>An MVC redirect result.</returns>
    public ActionResult SendAssertion()
    {
      var pendingRequest = ProviderEndpoint.PendingRequest;
      var authReq = pendingRequest as DotNetOpenAuth.OpenId.Provider.IAuthenticationRequest;
      var anonReq = pendingRequest as IAnonymousRequest;
      ProviderEndpoint.PendingRequest = null; // clear session static so we don't do this again
      if (pendingRequest == null)
      {
        throw new InvalidOperationException("There's no pending authentication request!");
      }

      // Set safe defaults if somehow the user ended up (perhaps through XSRF) here before electing to send data to the RP.
      if (anonReq != null && !anonReq.IsApproved.HasValue)
      {
        anonReq.IsApproved = false;
      }

      if (authReq != null && !authReq.IsAuthenticated.HasValue)
      {
        authReq.IsAuthenticated = false;
      }

      if (authReq != null && authReq.IsAuthenticated.Value)
      {
        if (authReq.IsDirectedIdentity)
        {
          authReq.LocalIdentifier = "http://ushadow.azurewebsites.net/account/user/FCEA4D97-E9D1-470C-A5A9-4D48A76F84B2";// Models.User.GetClaimedIdentifierForUser(User.Identity.Name);
        }

        if (!authReq.IsDelegatedIdentifier)
        {
          authReq.ClaimedIdentifier = authReq.LocalIdentifier;
        }
      }

      // Respond to AX/sreg extension requests only on a positive result.
      if ((authReq != null && authReq.IsAuthenticated.Value) ||
        (anonReq != null && anonReq.IsApproved.Value))
      {
        // Look for a Simple Registration request.  When the AXFetchAsSregTransform behavior is turned on
        // in the web.config file as it is in this sample, AX requests will come in as SReg requests.
        var claimsRequest = pendingRequest.GetExtension<ClaimsRequest>();
        if (claimsRequest != null)
        {
          var claimsResponse = claimsRequest.CreateResponse();

          // This simple respond to a request check may be enhanced to only respond to an individual attribute
          // request if the user consents to it explicitly, in which case this response extension creation can take
          // place in the confirmation page action rather than here.
          if (claimsRequest.Email != DemandLevel.NoRequest)
          {
            claimsResponse.Email = User.Identity.Name + "@dotnetopenauth.net";
          }

          pendingRequest.AddResponseExtension(claimsResponse);
        }

        // Look for PAPE requests.
        var papeRequest = pendingRequest.GetExtension<PolicyRequest>();
        if (papeRequest != null)
        {
          var papeResponse = new PolicyResponse();
          if (papeRequest.MaximumAuthenticationAge.HasValue)
          {
            papeResponse.AuthenticationTimeUtc = DateTime.UtcNow;
            //papeResponse.AuthenticationTimeUtc = this.FormsAuth.SignedInTimestampUtc;
          }

          pendingRequest.AddResponseExtension(papeResponse);
        }
      }

      return openIdProvider.PrepareResponse(pendingRequest).AsActionResult();
    }
  }
}
