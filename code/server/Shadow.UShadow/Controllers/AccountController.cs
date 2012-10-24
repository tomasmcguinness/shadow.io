using GoogleQRGenerator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Shadow.UShadow.Controllers
{
    public class AccountController : Controller
    {
        public ActionResult Logon()
        {
            return View();
        }

        public string LogonCode()
        {
            var googleQr = new GoogleQr("SomeDataToQRify", "200x200", true);
            return googleQr.ToString();
        }
    }
}
