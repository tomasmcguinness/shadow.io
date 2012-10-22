//
//  LocationManager.h
//  UShadow
//
//  Created by Tomas McGuinness on 19/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    @private
    UIBackgroundTaskIdentifier bgTask;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)trackUsersLocation;

@end
