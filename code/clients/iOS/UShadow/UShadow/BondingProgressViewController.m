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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.model verifyCode:@"+447943879135" code:@"ABC-123"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bondingStarted
{
    
}

- (void)bondingProgressUpdated
{
    [self.tableView reloadData];
}

- (void)bondingComplete
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
                //cell.accessoryView = v;
                //[v sizeToFit];
            }
            
            if(self.model.certificateGenerated)
            {
                cell.textLabel.text = @"Generating Certificate";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        case 2:
            
            cell.textLabel.text = @"Sending Certificate...";
            
            if(self.model.sendingCertificate)
            {
               
                //cell.accessoryView = v;
                //[v sizeToFit];
            }
            
            if(self.model.certificateSend)
            {
                cell.textLabel.text = @"Sending Certificate";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        case 3:
            cell.textLabel.text = @"Bonding Complete";
            break;
    }
    
    return cell;
}

@end
