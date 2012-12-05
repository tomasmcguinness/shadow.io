//
//  AuthenticateViewController.h
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "AuthenticationModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AuthorizationViewController.h"

@interface AuthenticateViewController : UIViewController<ZBarReaderDelegate, AuthenticationModelDelegate>

@property (nonatomic, strong) AuthenticationModel *model;

@end
