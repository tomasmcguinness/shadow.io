using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Shadow.UShadow.Models
{
  public class AuthenticationModel
  {
    public Guid RegisterAuthenticationRequest(DotNetOpenAuth.OpenId.Realm realm, string clientIpAddress)
    {
      Guid guid = Guid.NewGuid();

      // Put this guid into the cache.
      // With the realm.
      //
      HttpContext.Current.Cache.Add(guid.ToString(), realm, null, DateTime.Now.AddSeconds(30), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Low, null);

      return guid;
    }

    internal bool HasBeenAuthorized(Guid sessionId)
    {
      return false;
    }
  }
}