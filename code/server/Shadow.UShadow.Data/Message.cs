using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shadow.UShadow.Data
{
  public class Message
  {
    public string Id { get; set; }
    public Guid MessageId { get; set; }
    public string Body { get; set; }
  }
}
