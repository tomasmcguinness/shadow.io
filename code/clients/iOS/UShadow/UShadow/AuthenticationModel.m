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
    [request setValue:@"gzip" forHTTPHeaderField:@"accept-encoding"];
    
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
