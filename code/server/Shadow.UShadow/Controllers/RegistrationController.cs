using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Twilio;

namespace Shadow.UShadow.Controllers
{
  public partial class RegistrationController : Controller
    {
    public virtual ActionResult Index()
        {
            return View();
        }

        [HttpPost]
    public virtual ActionResult Index(string mobileNumber)
        {
            var twilio = new TwilioRestClient("ACb6efc5176b4649e9a49251ea9ca9c7b8", "18731aa1b2fefd01034cb4815bbf3c64");

            var message = string.Format("To pair your iPhone with your UShadow, click this link - http://ushadow.azurewebsites.net/Registration/Redirect?code={0}", Guid.NewGuid());

            twilio.SendSmsMessage("+442033222325", mobileNumber, message, (msg) =>
            {
                // TODO: Record the fact this sms was generated. The number should be used for verification.
            });

            return View();
        }

        public virtual ActionResult Redirect(Guid code)
        {
            return Redirect("ushadow://ushadow.azurewebsites.net?code=" + code);
        }
    }
}
