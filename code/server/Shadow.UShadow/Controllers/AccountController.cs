using GoogleQRGenerator;
using Shadow.UShadow.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Web.Mvc;
using System.Web.Security;

namespace Shadow.UShadow.Controllers
{
    public class AccountController : Controller
    {
        private AccountRepository respository;

        public AccountController()
        {
            respository = new AccountRepository();
        }

        public ActionResult User(string id)
        {
            return View("xrds");
        }

        public ActionResult Logon()
        {
            Guid sessionId = Guid.NewGuid();
            this.respository.Set(sessionId);
            return View(sessionId);
        }

        public ActionResult Logout()
        {
            this.respository.Unauthorize();
            FormsAuthentication.SignOut();
            return Redirect("/");
        }

        [HttpPost]
        public JsonResult CheckForAuthorization(Guid sessionId)
        {
            bool authorized = this.respository.IsAuthorized;

            if (authorized)
            {
                FormsAuthentication.SetAuthCookie(sessionId.ToString(), false);
            }

            return Json(authorized);
        }

        [HttpPost]
        public JsonResult PushAuthorizationCode(Guid sessionId)
        {
            if (this.respository.CurrentSessionId == sessionId)
            {
                this.respository.Authorize();
            }

            return Json(true);
        }
    }
}
