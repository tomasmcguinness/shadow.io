using Microsoft.WindowsAzure.StorageClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Shadow.UShadow.Data
{
    public class Location : TableServiceEntity
    {
        public Location()
        {

        }

        public Location(string ushadowId, DateTime now)
        {
            this.PartitionKey = ushadowId;
            this.RowKey = now.ToString().Replace("-", "").Replace("/", "");
            this.PositionRecoded = now;
        }

        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public DateTime PositionRecoded { get; set; }
    }
}
