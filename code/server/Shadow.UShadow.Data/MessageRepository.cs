using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Raven.Client.Document;
using Raven.Client.Embedded;

namespace Shadow.UShadow.Data
{
  public class MessageRepository
  {
    private DocumentStore documentStore;

    public MessageRepository()
    {
      documentStore = new EmbeddableDocumentStore()
      {
        ConnectionStringName = "RavenDb"
      };

      documentStore.Initialize();
    }

    public void SaveMessage(Message message)
    {
      using (var session = documentStore.OpenSession())
      {
        session.Store(message);
        session.SaveChanges();
      }
    }

    public ICollection<Message> Get()
    {
      using (var session = documentStore.OpenSession())
      {
        return session.Query<Message>().ToList();
      }
    }
  }
}
