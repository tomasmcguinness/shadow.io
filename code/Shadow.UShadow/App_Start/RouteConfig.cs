using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;

namespace Shadow.UShadow
{
  public class RouteConfig
  {
    public static void RegisterRoutes(RouteCollection routes)
    {
      routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

      routes.MapRoute(
        name: "Default",
        url: "Home/{action}/{id}",
        defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional });

      routes.MapHttpRoute(
          name: "DefaultApi",
          routeTemplate: "{controller}/{id}",
          defaults: new { controller = "Root", id = RouteParameter.Optional }
      );
    }
  }
}