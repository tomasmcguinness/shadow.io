//
//  BondingProgressViewController.h
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BondingModel.h"

@interface BondingProgressViewController : UITableViewController<BondingModelDelegate>

@property (nonatomic, strong) BondingModel *model;

@end
