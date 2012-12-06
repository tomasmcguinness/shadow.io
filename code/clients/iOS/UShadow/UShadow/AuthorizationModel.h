//
//  AuthorizationsModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 06/12/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Authorization.h"

@interface AuthorizationModel : NSObject

- (Authorization *)getAuthorizationForRealm:(NSString *)realm;
- (Authorization *)addAuthorizationForRealm:(NSString *)realm;

@end
