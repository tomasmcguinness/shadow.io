//
//  AuthenticationModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 27/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticationModelDelegate <NSObject>

- (void)promptForAuthorization:(NSString *)realm;
- (void)authorizationSent;
- (void)authorizationFailed;

@end

@interface AuthenticationModel : NSObject

- (void)sendAuthenticationCode:(NSString *)detectedCode;
- (void)sendAuthorization:(NSString *)session;
- (void)processAuthenticationCode:(NSString *)authenticationCode;

@property (strong, nonatomic) id<AuthenticationModelDelegate> delegate;

@end
