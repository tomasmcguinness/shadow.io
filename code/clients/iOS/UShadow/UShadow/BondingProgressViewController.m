//
//  BondingProgressViewController.m
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "BondingProgressViewController.h"

@interface BondingProgressViewController ()

@end

@implementation BondingProgressViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.model = [[BondingModel alloc] init];
        self.model.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Bonding...";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.model verifyCode:@"+447943879135" code:@"ABC-123"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bondingProgressUpdated
{
    [self.tableView reloadData];
}

- (void)bondingComplete
{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)next
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [v startAnimating];
    v.frame = CGRectMake(0, 0, 50, 44);
    
    switch(indexPath.row)
    {
        case 0:
            
            cell.textLabel.text = @"Verifying Credentials...";
            
            if(self.model.verifyingCredentials)
            {
                cell.accessoryView = v;
            }
            
            if(self.model.credentialsVerified)
            {
                cell.textLabel.text = @"Verifying Credentials";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        case 1:
            
            cell.textLabel.text = @"Generating Certificate...";
            
            if(self.model.generatingCertificate)
            {
                cell.accessoryView = v;
            }
            
            if(self.model.certificateGenerated)
            {
                cell.textLabel.text = @"Generating Certificate";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        case 2:
            
            cell.textLabel.text = @"Bonding...";
            
            if(self.model.completingBonding)
            {
                cell.accessoryView = v;
            }
            
            if(self.model.bondingComplete)
            {
                cell.textLabel.text = @"Bonding";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
    }
    
    return cell;
}

@end
