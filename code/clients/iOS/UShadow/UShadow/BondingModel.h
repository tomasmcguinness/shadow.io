//
//  BondingModel.h
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaggedNSURLConnection.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@protocol BondingModelDelegate <NSObject>

- (void)bondingProgressUpdated;
- (void)bondingComplete;

@end

@interface BondingModel : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *smsNumber;
@property (nonatomic, strong) NSString *detectedCode;

@property (strong, nonatomic) NSMutableData *returnedData;

@property (nonatomic, strong) TaggedNSURLConnection *connection;

@property (nonatomic, strong) id<BondingModelDelegate> delegate;
@property (nonatomic) BOOL verifyingCredentials;
@property (nonatomic) BOOL credentialsVerified;
@property (nonatomic) BOOL generatingCertificate;
@property (nonatomic) BOOL certificateGenerated;
@property (nonatomic) BOOL completingBonding;
@property (nonatomic) BOOL bondingComplete;

- (void)verifyCode:(NSString *)smsNumber code:(NSString *)detectedCode;

@end
