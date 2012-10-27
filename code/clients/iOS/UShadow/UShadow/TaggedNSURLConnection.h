//
//  TaggedNSURLConnection.h
//  UShadow
//
//  Created by Tomas McGuinness on 27/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaggedNSURLConnection : NSURLConnection

@property (nonatomic) NSInteger tag;

@end
