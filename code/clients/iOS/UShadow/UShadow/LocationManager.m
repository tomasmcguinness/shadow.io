//
//  LocationManager.m
//  UShadow
//
//  Created by Tomas McGuinness on 19/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

@synthesize locationManager;

- (void)trackUsersLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@://%@/shadow/location?lat=%f&long=%f",
                           @"http",
                           @"ushadow.azurewebsites.net",
                           newLocation.coordinate.latitude,
                           newLocation.coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [requestObj setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [requestObj setHTTPMethod:@"PUT"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestObj queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [queue release];
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
         
         if(error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
//                 DLog(@"Commute Save Failed: %@", [error localizedDescription]);
             });
         }
         else
         {
             if(httpResp.statusCode == 200)
             {
//                 DLog(@"Commute saved!");
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [self.delegate saveCommuteComplete];
//                 });
             }
             else
             {
//                 DLog(@"Commute service returned an error");
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [self.delegate saveCommuteFailed:@"An enxpected error occurred. Please try again."];
//                 });
             }
         }
     }];
}


@end