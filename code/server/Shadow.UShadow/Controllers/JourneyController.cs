﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Shadow.UShadow.Controllers
{
  public partial class JourneyController : Controller
    {
    public virtual ActionResult Index()
        {
            return View();
        }
    }
}
