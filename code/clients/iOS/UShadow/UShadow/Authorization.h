//
//  Authorizations.h
//  UShadow
//
//  Created by Tomas McGuinness on 06/12/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Authorization : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * relayingParty;

@end
