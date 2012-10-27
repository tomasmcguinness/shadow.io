using Org.BouncyCastle.Asn1.X509;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Generators;
using Org.BouncyCastle.Math;
using Org.BouncyCastle.OpenSsl;
using Org.BouncyCastle.Pkcs;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.X509;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
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

            string certSubjectName = "UShadow_RSA";
            var certName = new X509Name("CN=" + certSubjectName);
            var serialNo = BigInteger.ProbablePrime(120, new Random());

            X509V3CertificateGenerator gen2 = new X509V3CertificateGenerator();
            gen2.SetSerialNumber(serialNo);
            gen2.SetSubjectDN(certName);
            gen2.SetIssuerDN(new X509Name(true, "CN=UShadow"));
            gen2.SetNotBefore(DateTime.Now.Subtract(new TimeSpan(30, 0, 0, 0)));
            gen2.SetNotAfter(DateTime.Now.AddYears(2));
            gen2.SetSignatureAlgorithm("sha512WithRSA");

            gen2.SetPublicKey(keys.Public);

            Org.BouncyCastle.X509.X509Certificate newCert = gen2.Generate(keys.Private);

            Pkcs12Store store = new Pkcs12StoreBuilder().Build();

            X509CertificateEntry certEntry = new X509CertificateEntry(newCert);
            store.SetCertificateEntry(newCert.SubjectDN.ToString(), certEntry);

            AsymmetricKeyEntry keyEntry = new AsymmetricKeyEntry(keys.Private);
            store.SetKeyEntry(newCert.SubjectDN.ToString() + "_key", keyEntry, new X509CertificateEntry[] { certEntry });

            using (MemoryStream ms = new MemoryStream())
            {
                store.Save(ms, "Password".ToCharArray(), new SecureRandom());

                var resp = new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new ByteArrayContent(ms.ToArray())
                };

                resp.Content.Headers.Add("Content-Type", "application/x-pkcs12");
                return resp;
            }
        }

        public HttpResponseMessage Put()
        {
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}