using Shadow.UShadow.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Shadow.UShadow.Controllers
{
    [Authorize]
    public class LocationsController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [OutputCache(Duration = 0)]
        public JsonResult Locations()
        {
            LocationRepository resp = new LocationRepository();
            return Json(resp.Get(), JsonRequestBehavior.AllowGet);
        }
    }
}
