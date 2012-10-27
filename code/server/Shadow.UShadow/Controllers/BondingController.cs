using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Generators;
using Org.BouncyCastle.OpenSsl;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Web.Http;

namespace Shadow.UShadow.Controllers
{
    public class BondingController : ApiController
    {
        public HttpResponseMessage Post(string smsNumber, string code)
        {
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        public HttpResponseMessage Get(string smsNumber, string code)
        {
            RsaKeyPairGenerator r = new RsaKeyPairGenerator();
            r.Init(new Org.BouncyCastle.Crypto.KeyGenerationParameters(new Org.BouncyCastle.Security.SecureRandom(), 2048));

            AsymmetricCipherKeyPair keys = r.GenerateKeyPair();

            string publicKeyPath = Path.Combine(Path.GetTempPath(), "publicKey.key");

            if (File.Exists(publicKeyPath))
            {
                File.Delete(publicKeyPath);
            }

            using (TextWriter textWriter = new StreamWriter(publicKeyPath, false))
            {
                PemWriter pemWriter = new PemWriter(textWriter);
                pemWriter.WriteObject(keys.Public);
                pemWriter.Writer.Flush();
            }

            using (TextWriter textWriter = new StringWriter())
            {
                PemWriter pemWriter = new PemWriter(textWriter);
                pemWriter.WriteObject(keys.Private);
                pemWriter.Writer.Flush();

                return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(textWriter.ToString())
                };
            }
        }

        public HttpResponseMessage Put()
        {
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}