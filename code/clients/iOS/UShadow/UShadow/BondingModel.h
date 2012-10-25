//
//  BondingModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BondingModelDelegate <NSObject>

- (void)verifyCodeComplete;

@end

@interface BondingModel : NSObject

- (void)verifyCode:(NSString *)detectedCode;

@end
