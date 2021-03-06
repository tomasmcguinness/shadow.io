//
//  AppDelegate.m
//  UShadow
//
//  Created by Tomas McGuinness on 19/09/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.locationManager = [[LocationManager alloc] init];
    [self.locationManager trackUsersLocation];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UITabBarController *rootTabBarController = [[UITabBarController alloc] init];
    
    TrustedShadowViewController *shadowController = [[TrustedShadowViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:shadowController];
    navCon.tabBarItem.title = @"Shadows";
    
    AuthenticateViewController *authenticateController = [[AuthenticateViewController alloc] init];
    UINavigationController *authNavCon = [[UINavigationController alloc] initWithRootViewController:authenticateController];
    authNavCon.tabBarItem.title = @"Authenticate";
    
    AccountsViewController *accountsController = [[AccountsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *accsNavCon = [[UINavigationController alloc] initWithRootViewController:accountsController];
    accsNavCon.tabBarItem.title = @"Accounts";
    
    rootTabBarController.viewControllers = [NSArray arrayWithObjects:navCon, authNavCon, accsNavCon, nil];
    
    self.window.rootViewController = rootTabBarController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Notification Received!");
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Opened by URL [%@]", url);
    
    BondingViewController *bondingController = [[BondingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    bondingController.navigationItem.title = @"Bonding";
    UINavigationController *bondingNavController = [[UINavigationController alloc] initWithRootViewController:bondingController];
    
    [self.window.rootViewController presentViewController:bondingNavController animated:YES completion:nil];
    
    return TRUE;
}

#pragma mark - Remote Notification Registration

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    const void *devTokenBytes = [devToken bytes];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UShadow" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UShadow.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location Updated");
//    UIApplication *app = [UIApplication sharedApplication];
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@://%@/shadow/location?lat=%f&long=%f",
//                           @"http",
//                           @"ushadow.azurewebsites.net",
//                           newLocation.coordinate.latitude,
//                           newLocation.coordinate.longitude];
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
//    [requestObj setValue:@"application/json" forHTTPHeaderField:@"content-type"];
//    [requestObj setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    [requestObj setHTTPMethod:@"PUT"];
//    
//    NSLog(@"Requesting [%@]", urlString);
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [NSURLConnection sendAsynchronousRequest:requestObj queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         [queue release];
//         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
//         
//         if(error)
//         {
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 NSLog(@"Submit failed: %@", [error localizedDescription]);
//             });
//         }
//         else
//         {
//             if(httpResp.statusCode == 200)
//             {
//                 //                 DLog(@"Commute saved!");
//                 //                 dispatch_async(dispatch_get_main_queue(), ^{
//                 //                     [self.delegate saveCommuteComplete];
//                 //                 });
//             }
//             else
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     NSLog(@"Submit failed: %@", [error localizedDescription]);
//                 });
//             }
//         }
//     }];
}

@end
