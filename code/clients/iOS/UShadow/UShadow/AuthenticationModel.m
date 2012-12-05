//
//  AuthenticationModel.m
//  UShadow
//
//  Created by Tomas McGuinness on 27/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel

- (void)processAuthenticationCode:(NSString *)authenticationCode
{
    // Split the code. It should be <Session>|<Realm>
    NSArray *codeParts = [authenticationCode componentsSeparatedByString:@"|"];
    
    NSLog(@"SessionId: %@", [codeParts objectAtIndex:0]);
    NSLog(@"Realm: %@", [codeParts objectAtIndex:1]);
    
    [self.delegate promptForAuthorization:[codeParts objectAtIndex:1]];
}

- (void)sendAuthorization:(NSString *)session
{
    //NSString *url = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/account/pushauthorizationcode?sessionId=%@", detectedCode];
    
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //[request setHTTPMethod:@"POST"];
}

- (void)sendAuthenticationCode:(NSString *)detectedCode
{
    NSString *url = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/account/pushauthorizationcode?sessionId=%@", detectedCode];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];

    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //NSString *fileName = [NSString stringWithFormat:@"%@/cert.p12", documentsDirectory];
    
    //NSData *certData = [NSData dataWithContentsOfFile:fileName];
    //NSLog(@"Loaded NSData [%d bytes]", [certData length]);
    
    //CFDataRef inPKCS12Data = (CFDataRef)certData;
    
    ///SecIdentityRef myIdentity;
    //SecTrustRef myTrust;
    //OSStatus status = extractIdentityAndTrust(inPKCS12Data, &myIdentity, &myTrust);
    
    //SecKeyRef publicKey;
    
    //status = SecIdentityCopyPrivateKey (myIdentity, &publicKey);
    
    //NSData *signedData = [self signData:[detectedCode dataUsingEncoding:NSUTF8StringEncoding] key:publicKey];
    
    //NSLog(@"Signed Data [%@]", signedData);
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [queue release];
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
         
         if(error)
         {
             NSLog(@"Error getting response: %@", [error localizedDescription]);
         }
         else
         {
             if(httpResp.statusCode == 200)
             {
                 NSLog(@"Successfully pushed the authorization code");
             }
             else
             {
                 NSLog(@"Eror pushing authorization code");
             }
         }
     }];
}
/*
OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data, SecIdentityRef *outIdentity, SecTrustRef *outTrust)
{
    OSStatus securityError = errSecSuccess;
    
    NSMutableDictionary *optionsDictionary = [[NSMutableDictionary alloc] init];
	
	// Set the public key query dictionary.
    [optionsDictionary setObject:@"Password" forKey:(id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, 0, 0, NULL);
    
    securityError = SecPKCS12Import(inPKCS12Data,
                                    (CFDictionaryRef)optionsDictionary,
                                    &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)
        CFRelease(optionsDictionary);
    
    return noErr;
}

- (NSData *)signData:(NSData *)input key:(SecKeyRef)key
{
    NSLog(@"Signing [%@]", [[NSString alloc] initWithBytes:[input bytes] length:input.length encoding:NSUTF8StringEncoding]);
    NSLog(@"Length [%d]", input.length);
    
    
    
#define CC_SHA1_DIGEST_LENGTH 50
    
#define kTypeOfWrapPadding      kSecPaddingPKCS1
    
    //start of code that extracts identity and evaluates certificate trust
    
    // ----some code
    // ----some code
    
    // End of code that extracts identity and evaluate certificate trust
    
    uint8_t *plainBuffer;
    uint8_t * signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData * signedHash = nil;
    
    //NSString *str = [[NSString alloc] initWithBytes:[input bytes] length:input.length encoding:NSUTF8StringEncoding];
    //char inputString = (char)[input bytes];
    char inputString = *"Company Confidential";   // I want this input Text to appear on PDF file
    
    int len = strlen(&inputString);
    
    plainBuffer = (uint8_t *)calloc(len, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, &inputString, len);
    
    signedBytesSize = SecKeyGetBlockSize(key);
    
    // Malloc a buffer to hold signature.
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) );
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(key,
                                kSecPaddingPKCS1,
                                (const uint8_t *)[input bytes],
                                CC_SHA1_DIGEST_LENGTH,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    
    NSLog(@"signed hash is=%@", signedHash);
    
    
    
    //    OSStatus sanityCheck = noErr;
    //    NSData * signedHash = nil;
    //
    //    uint8_t * signedBytes = NULL;
    //    uint8_t * signature = NULL;
    //    size_t signatureSize = SecKeyGetBlockSize(key);
    //
    //    // Malloc a buffer to hold signature.
    //    signature = malloc( signatureSize );
    //    memset((void *)signature, 0x0, signatureSize);
    //
    //    sanityCheck = SecKeyRawSign(key,
    //                                kSecPaddingNone,
    //                                (const uint8_t *)&input,
    //                                (size_t)input.length,
    //                                (uint8_t *)signature,
    //                                &signatureSize);
    //
    //    signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signatureSize];
    //
    //    NSLog(@"%@", signedHash);
    //
    //[Base64 initialize];
    //NSString *b64EncStr = [Base64 encode:signedHash];
    //NSLog(@"%@", b64EncStr);
    //NSLog(@"String Length: %d", b64EncStr.length);
    
    
    //    // Sign the SHA1 hash.
    //    NSData *checksum = [self checksumSHA1:[input bytes] length:[input length]];
    //
    //    sanityCheck = SecKeyRawSign(key,
    //                                kSecPaddingPKCS1SHA1,
    //                                (const uint8_t *)[input bytes],
    //                                2048,
    //                                signature,
    //                                &signatureSize);
    
    //CHECK_CONDITION1(sanityCheck == noErr, @"Problem signing the SHA1 hash, OSStatus == %d.", sanityCheck );
    
    // Build up signed SHA1 blob.
    //signedHash = [NSData dataWithBytes:(const void *)signature length:(NSUInteger)signatureSize];
    //if (signature) free(signature);
    
    return signedHash;
}
*/
@end
