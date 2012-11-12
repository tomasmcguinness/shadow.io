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
@synthesize smsNumber;
@synthesize detectedCode;

- (void)verifyCode:(NSString *)smsNumberOrNil code:(NSString *)detectedCodeOrNil
{
    self.smsNumber = smsNumberOrNil;
    self.detectedCode = detectedCodeOrNil;

    self.verifyingCredentials = YES;
    self.credentialsVerified = NO;
    self.generatingCertificate = NO;
    self.certificateGenerated = NO;
    self.completingBonding = NO;
    self.bondingComplete = NO;
    
    // First step, verify the sms and code are valid.
    //
    NSString *requestString = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/shadow/bonding?smsNumber=%@&code=%@", self.smsNumber, self.detectedCode];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"Sending POST to [%@]", requestString);
    
    self.connection = [[TaggedNSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection.tag = 0;
    [self.connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
    NSLog(@"Response: %d", httpResp.statusCode);
    
    if(httpResp.statusCode == 200)
    {
        self.returnedData = [[NSMutableData alloc] initWithCapacity:0]; 
    }
    else
    {
        [self.connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Data Recived");
    [self.returnedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.connection.tag == 0)
    {
        NSLog(@"Settings verified. Requesting KeyPair generation...");
        
        self.verifyingCredentials = NO;
        self.credentialsVerified = YES;
        self.generatingCertificate = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [self requestCertificate];
    }
    else if(self.connection.tag == 1)
    {
        NSLog(@"Key Pair generated.");
        
        self.generatingCertificate = NO;
        self.certificateGenerated = YES;
        self.completingBonding = YES;
        
        NSLog(@"Returned [%d] bytes", [self.returnedData length]);
        
        [self writeToTextFile:self.returnedData];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
        
        [self checkSigning];
    }
    else if(self.connection.tag == 2)
    {
        self.completingBonding = NO;
        self.bondingComplete = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.delegate bondingProgressUpdated];
        });
    }
}

-(void) writeToTextFile:(NSData *)content
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/cert.p12",  documentsDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:fileName];
    NSLog(@"Path to file: %@", fileName);
    NSLog(@"File exists: %d", fileExists);

    if (fileExists)
    {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:fileName error:&error];
    }

    //save content to the documents directory
    [content writeToFile:fileName atomically:YES];
}

- (void)requestCertificate
{
    NSString *requestString = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/shadow/bonding?smsNumber=%@&code=%@", self.smsNumber, self.detectedCode];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"GET"];
    
    NSLog(@"Sending GET to [%@]", requestString);
    
    self.connection = [[TaggedNSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection.tag = 1;
    [self.connection start];
}

- (void)checkSigning
{
    OSStatus SecKeyRawSign (
                            SecKeyRef key,
                            SecPadding padding,
                            const uint8_t *dataToSign,
                            size_t dataToSignLen,
                            uint8_t *sig,
                            size_t *sigLen
                            );
    
    NSString *data = [NSString stringWithFormat:@"smsNumber=%@&code=%@", self.smsNumber, self.detectedCode];
    
    NSString *requestString = [NSString stringWithFormat:@"http://ushadow.azurewebsites.net/shadow/bonding?%@",data];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"PUT"];
    
    NSLog(@"Sending PUT to [%@]", requestString);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/cert.p12", documentsDirectory];
    
    NSData *certData = [NSData dataWithContentsOfFile:fileName];
    NSLog(@"Loaded NSData [%d bytes]", [certData length]);
    
    CFDataRef inPKCS12Data = (CFDataRef)certData;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust(inPKCS12Data, &myIdentity, &myTrust);
    
    SecKeyRef publicKey;

    status = SecIdentityCopyPrivateKey (myIdentity, &publicKey);
    
    NSData *signedData = [self signData:[data dataUsingEncoding:NSUTF8StringEncoding] key:publicKey];
    
    NSLog(@"Signed Data [%@]", signedData);
    
    [request setHTTPBody:signedData];
    
    self.connection = [[TaggedNSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection.tag = 2;
    [self.connection start];
}

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
    
    uint8_t * signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData * signedHash = nil;
    
    // Hash the data before signing it.
    //
    NSMutableData *hashedInput = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(input.bytes, input.length, hashedInput.mutableBytes);
    
    signedBytesSize = SecKeyGetBlockSize(key);
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) );
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(key,
                                kSecPaddingPKCS1SHA256,
                                (const uint8_t *)[hashedInput bytes],
                                CC_SHA256_DIGEST_LENGTH,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    
    NSLog(@"signed hash is=%@", signedHash);
    
    return signedHash;
}
@end
