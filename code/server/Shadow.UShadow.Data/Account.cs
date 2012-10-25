using Microsoft.WindowsAzure.StorageClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Shadow.UShadow.Data
{
    public class Account : TableServiceEntity
    {
        public Account()
        { }

        public Account(string ushadowId)
        {
            this.PartitionKey = ushadowId;
            this.RowKey = ushadowId;
        }

        public Guid AuthorizationCode { get; set; }
        public Boolean Authorized { get; set; }
        public DateTime Generated { get; set; }
    }
}
