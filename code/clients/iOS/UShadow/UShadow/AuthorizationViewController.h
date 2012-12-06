//
//  ApproveAccessViewController.h
//  UShadow
//
//  Created by Tomas McGuinness on 04/12/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationViewController : UITableViewController
{
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
