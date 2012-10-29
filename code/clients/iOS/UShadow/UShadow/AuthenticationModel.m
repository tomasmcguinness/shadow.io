//
//  AuthenticationModel.m
//  UShadow
//
//  Created by Tomas McGuinness on 27/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel

- (void)sendAuthenticationCode:(NSString *)detectedCode
{
    NSString *url = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/account/pushauthorizationcode?sessionId=%@", detectedCode];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/cert.p12", documentsDirectory];
    
    NSData *certData = [NSData dataWithContentsOfFile:fileName];
    NSLog(@"Loaded NSData [%d bytes]", [certData length]);
    
    CFDataRef inPKCS12Data = (CFDataRef)certData;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust(inPKCS12Data, &myIdentity, &myTrust);
    
    SecKeyRef publicKey;
    
    status = SecIdentityCopyPrivateKey (myIdentity, &publicKey);
    
    NSData *signedData = [self signData:[a dataUsingEncoding:NSUTF8StringEncoding] key:publicKey];
    
    NSLog(@"Signed Data [%@]", signedData);
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [queue release];
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
         
         if(error)
         {
             NSLog(@"Error getting response: %@", [error localizedDescription]);
         }
         else
         {
             if(httpResp.statusCode == 200)
             {
                 NSLog(@"Successfully pushed the authorization code");
             }
             else
             {
                 NSLog(@"Eror pushing authorization code");
             }
         }
     }];
}

@end
