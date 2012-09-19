# Messaging

Messaging is simple interface that allows messages of all types to be sent directly to the user's U-Shadow. 

## Authentication ##

At present there is no authentication. The Authentiction will reside in the header, so the source of the message can be verified.

## Intelligence ##

By differentiating between authorized and unautohirzed messages, the U-Shadow can perform actions appropriate to the message, such as alerting the user if a message is from their parent or partner. Unauthenticted messages could be immediately discarded or quarantined by the U-Shadow, depending on the user's preferences.

Another benefit is that messages could be rejected at source if there are too many outstanding. This would reduce the inbox overload by pushing back on the sender. The sender could then schedule redelivery if the message was of low priority.

## Interface ##

To instruct your U-Shadow to send a message to another U-Shadow, a PUT must be sent. This contains the destination and the content of the message.

Request 

	PUT /messages HTTP/1.1

Response

	{
		"to":"www.recipientshadow.com",
		"body":"The message you want to send",
		"priority":"low"
	}

A U-Shadow delivers the message by POST'ing it to it's destination. The U-Shadow would be responsible for applying all authentication information to the header of the message. When a U-Shadow receives a message, it should assign it a GUID that represents its message_id. This will help identify all messages.

Request

    POST /messages HTTP/1.1

Response

    {
		"from":"Sender's Name",
		"body":"The message body",
		"priority":"high"
	}

A User retrieves all messages from the U-Shadow by issuing a GET. This request should support filtering.

Request
	
	GET /messages HTTP/1.1

Response

	{
		"messages": 
		[
			{
				"message_id":"111111-1111-1111-111111111111",
				"from":"Sender's Name",
				"body":"The message body",
				"time":"2012-09-17T12:00:00"
				"read":false
				"flagged":false
			}
		]
	}

A user's U-Shadow client can mark messages as read, flagged etc. by issuing PATCH requests.

Request

	PATCH /messages/111111-1111-1111-111111111111 HTTP/1.1

Response

	{
		"read":true
		"flagged":true
	}

A message can be permanently erased with a DELETE command.

Request

	DELETE /messages/111111-1111-1111-111111111111 HTTP/1.1



