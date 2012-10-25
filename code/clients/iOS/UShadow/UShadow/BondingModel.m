//
//  BondingModel.m
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "BondingModel.h"

@implementation BondingModel

@synthesize delegate;

- (void)verifyCode:(NSString *)smsNumber code:(NSString *)detectedCode
{
    self.verifyingCredentials = NO;
    self.credentialsVerified = NO;
    self.generatingCertificate = NO;
    self.certificateGenerated = NO;
    self.sendingCertificate = NO;
    self.certificateSend = NO;
    self.bondingComplete = NO;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.verifyingCredentials = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingStarted];
        });
        
        [NSThread sleepForTimeInterval:5];
        
        self.verifyingCredentials = NO;
        self.credentialsVerified = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [NSThread sleepForTimeInterval:5];
        
        self.generatingCertificate = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [NSThread sleepForTimeInterval:5];
        
        self.generatingCertificate = NO;
        self.certificateGenerated = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [NSThread sleepForTimeInterval:5];
        
        self.sendingCertificate = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [NSThread sleepForTimeInterval:5];
        
        self.sendingCertificate = NO;
        self.certificateSend = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [NSThread sleepForTimeInterval:5];
        self.bondingComplete = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
    });
}

@end
