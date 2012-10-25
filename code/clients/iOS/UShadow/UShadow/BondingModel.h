//
//  BondingModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BondingModelDelegate <NSObject>

- (void)bondingStarted;
- (void)bondingProgressUpdated;
- (void)bondingComplete;

@end

@interface BondingModel : NSObject

@property (nonatomic, strong) id<BondingModelDelegate> delegate;
@property (nonatomic) BOOL verifyingCredentials;
@property (nonatomic) BOOL credentialsVerified;
@property (nonatomic) BOOL generatingCertificate;
@property (nonatomic) BOOL certificateGenerated;
@property (nonatomic) BOOL sendingCertificate;
@property (nonatomic) BOOL certificateSend;
@property (nonatomic) BOOL bondingComplete;

- (void)verifyCode:(NSString *)smsNumber code:(NSString *)detectedCode;

@end
