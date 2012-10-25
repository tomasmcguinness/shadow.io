//
//  AppDelegate.h
//  UShadow
//
//  Created by Tomas McGuinness on 19/09/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TrustedShadowViewController.h"
#import "LocationManager.h"
#import "AuthenticateViewController.h"
#import "BondingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
@private
    UIBackgroundTaskIdentifier bgTask;

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) LocationManager *locationManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
