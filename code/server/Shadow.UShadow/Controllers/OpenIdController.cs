using DotNetOpenAuth.OpenId.Extensions.ProviderAuthenticationPolicy;
using DotNetOpenAuth.OpenId.Extensions.SimpleRegistration;
using DotNetOpenAuth.OpenId.Provider;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Shadow.UShadow.Controllers
{
  public class OpenIdController : Controller
  {
    internal static OpenIdProvider openIdProvider = new OpenIdProvider();

    public ActionResult Index()
        {
            IRequest request = openIdProvider.GetRequest();

            ProviderEndpoint.PendingRequest = (IHostProcessedRequest)request;

            var pendingRequest = ProviderEndpoint.PendingRequest;
            var authReq = pendingRequest as IAuthenticationRequest;
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
                //authReq.LocalIdentifier = Models.User.GetClaimedIdentifierForUser(User.Identity.Name);
                authReq.LocalIdentifier = new Uri("Test");
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
                }

                pendingRequest.AddResponseExtension(papeResponse);
              }
            }

            return openIdProvider.PrepareResponse(pendingRequest).AsActionResult();
        }
  }
}
