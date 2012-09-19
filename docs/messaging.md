# Messaging

Messaging is simple interface that allows messages of all types to be sent directly to the user's U-Shadow. 

## Authentication ##

At present there is no authentication. The Authentiction will reside in the header, so the source of the message can be verified. This will allow the U-Shadow to perform actions appropriate to authenticated messages, such as alerting the user. Unauthenticted messages could be immediately discarded or quarantined by the U-Shadow, depending on the user's preferences.

## Interface ##

    PUT /messages HTTP/1.1

    {
		"sender":"Sender's Name",
		"body":"The message body"
	}

	
	GET /messages HTTP/1.1

	{
		"messages": 
		[
			{
				"sender":"Sender's Name",
				"body":"The message body",
				"time":"2012-09-17T12:00:00"
			}
		]
	}

	POST /messages HTTP/1.1

	{
		"to":"www.recipientshadow.com",
		"body":"The message you want to send"
	}




