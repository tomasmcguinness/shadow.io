using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Raven.Client.Document;

namespace Shadow.UShadow.Data
{
  public class MessageRepository
  {
    private DocumentStore documentStore;

    public MessageRepository()
    {
      documentStore = new DocumentStore()
      {
        Url = "http://localhost/"
      };

      documentStore.Initialize();
    }

    public void SaveMessage(Message message)
    {

    }
  }
}
