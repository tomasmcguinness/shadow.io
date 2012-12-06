//
//  AuthenticationModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 27/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorizationModel.h"

@protocol AuthenticationModelDelegate <NSObject>

- (void)promptForAuthorization:(NSString *)realm;
- (void)authorizationSent;
- (void)authorizationFailed;

@end

@interface AuthenticationModel : NSObject

- (void)sendAuthenticationCode:(NSString *)detectedCode managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
//- (void)sendAuthorization:(NSString *)session managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)processAuthenticationCode:(NSString *)authenticationCode managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (strong, nonatomic) id<AuthenticationModelDelegate> delegate;
@property (strong, nonatomic) AuthorizationModel *authorizationModel;

@end
