using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.StorageClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;

namespace Shadow.UShadow.Data
{
    public class LocationRepository
    {
        public LocationRepository()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);

            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();

            // Create the table if it doesn't exist
            string tableName = "locations";
            tableClient.CreateTableIfNotExist(tableName);
        }

        public void Add(Location location)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.AppSettings["StorageConnectionString"]);

            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();

            TableServiceContext serviceContext = tableClient.GetDataServiceContext();

            // Add the new customer to the people table
            serviceContext.AddObject("locations", location);

            // Submit the operation to the table service
            serviceContext.SaveChanges();
        }
    }
}
