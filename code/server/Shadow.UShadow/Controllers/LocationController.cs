using Shadow.UShadow.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Shadow.UShadow.Controllers
{
    public class LocationController : ApiController
    {
        // POST api/location
        public void Post(string lat, string @long)
        {
            LocationRepository rep = new LocationRepository();

            DateTime now = DateTime.UtcNow;

            Location location = new Location("1", now)
            {
                Latitude = double.Parse(lat),
                Longitude = double.Parse(@long)
            };

            rep.Add(location);
        }
    }
}
