using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.StorageClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;

namespace Shadow.UShadow.Data
{
    public class AccountRepository
    {
        public AccountRepository()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();

            // Create the table if it doesn't exist
            string tableName = "account";
            tableClient.CreateTableIfNotExist(tableName);
        }

        public void Set(Guid authorizationCode)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
            TableServiceContext serviceContext = tableClient.GetDataServiceContext();

            serviceContext.ResolveType = (unused) => typeof(Account);

            var existingAccount = serviceContext.CreateQuery<Account>("account").SingleOrDefault();

            if (existingAccount == null)
            {
                existingAccount = new Account("1");
                serviceContext.AddObject("account", existingAccount);
            }

            existingAccount.AuthorizationCode = authorizationCode;
            existingAccount.Generated = DateTime.UtcNow;

            serviceContext.UpdateObject(existingAccount);
            serviceContext.SaveChanges();
        }

        public void Set(Boolean authorized)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
            TableServiceContext serviceContext = tableClient.GetDataServiceContext();

            serviceContext.ResolveType = (unused) => typeof(Account);

            var existingAccount = serviceContext.CreateQuery<Account>("account").SingleOrDefault();

            if (existingAccount == null)
            {
                existingAccount = new Account("1");
                serviceContext.AddObject("account", existingAccount);
            }

            existingAccount.Authorized = authorized;

            serviceContext.UpdateObject(existingAccount);
            serviceContext.SaveChanges();
        }

        public Account Get()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
            TableServiceContext serviceContext = tableClient.GetDataServiceContext();

            serviceContext.ResolveType = (unused) => typeof(Account);

            var existingAccount = serviceContext.CreateQuery<Account>("account").SingleOrDefault();

            if (existingAccount == null)
            {
                existingAccount = new Account("1");
                serviceContext.AddObject("account", existingAccount);
                serviceContext.SaveChanges();
            }

            return existingAccount;
        }

        public void Authorize()
        {
            Set(true);
        }

        public void Unauthorize()
        {
            Set(false);
        }

        public bool IsAuthorized { get { return Get().Authorized; } }

        public Guid CurrentSessionId { get { return Get().AuthorizationCode; } }
    }
}
