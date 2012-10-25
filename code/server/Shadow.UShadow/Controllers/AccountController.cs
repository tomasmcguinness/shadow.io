using GoogleQRGenerator;
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
    public ActionResult Logon()
    {
      Guid sessionId = Guid.NewGuid();
      System.Web.HttpContext.Current.Cache.Add("SessionId", sessionId, null, DateTime.Now.AddSeconds(30), Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
      System.Web.HttpContext.Current.Cache.Add("Authorized", false, null, Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
      return View(sessionId);
    }

    public ActionResult Logout()
    {
      System.Web.HttpContext.Current.Cache["Authorized"] = false;
      FormsAuthentication.SignOut();
      return Redirect("/");
    }

    [HttpPost]
    public JsonResult CheckForAuthorization(Guid sessionId)
    {
      if (System.Web.HttpContext.Current.Cache["Authorized"] != null && (Boolean)System.Web.HttpContext.Current.Cache["Authorized"])
      {
        FormsAuthentication.SetAuthCookie(sessionId.ToString(), false);
      }

      return Json((Boolean)System.Web.HttpContext.Current.Cache["Authorized"]);
    }

    [HttpPost]
    public JsonResult PushAuthorizationCode(Guid sessionId)
    {
      if ((Guid)System.Web.HttpContext.Current.Cache["SessionId"] == sessionId)
      {
        System.Web.HttpContext.Current.Cache["Authorized"] = true;
      }

      return Json(true);
    }
  }
}
