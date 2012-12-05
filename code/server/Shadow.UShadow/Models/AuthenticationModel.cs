using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Web;

namespace Shadow.UShadow.Models
{
  public class AuthenticationModel
  {
    public Guid RegisterAuthenticationRequest(DotNetOpenAuth.OpenId.Realm realm, string clientIpAddress)
    {
      Guid guid = Guid.NewGuid();

      // Put this guid into the cache.
      HttpContext.Current.Cache.Add(guid.ToString(), false, null, DateTime.Now.AddSeconds(30), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Low, null);

      return guid;
    }

    public bool HasBeenAuthorized(Guid sessionId)
    {
      var isAuthorized = (bool)HttpContext.Current.Cache[sessionId.ToString()];
      if(isAuthorized)
      {
        HttpContext.Current.Cache.Remove(sessionId.ToString());
      }
      return isAuthorized;
    }

    internal void Authorized(Guid sessionId)
    {
      if (HttpContext.Current.Cache[sessionId.ToString()] == null)
      {
        throw new SecurityException();
      }

      HttpContext.Current.Cache[sessionId.ToString()] = true;
    }
  }
}