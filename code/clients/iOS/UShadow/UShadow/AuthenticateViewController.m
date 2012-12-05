//
//  AuthenticateViewController.m
//  UShadow
//
//  Created by Tomas McGuinness on 25/10/2012.
//  Copyright (c) 2012 tomasmcguinness.com. All rights reserved.
//

#import "AuthenticateViewController.h"

@interface AuthenticateViewController ()

@end

@implementation AuthenticateViewController

@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.model = [[AuthenticationModel alloc] init];
        self.model.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button.frame = CGRectMake(10, 100, 300, 50);
    //button.titleLabel.text = @"Authenticate";
    //button.titleLabel.textColor  = [UIColor redColor];
    //[button addTarget:self action:@selector(launchQRReader) forControlEvents:UIControlEventAllTouchEvents];
    //[self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self launchQRReader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launchQRReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    reader.readerView.zoom = 1.0;
    
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
    self.tabBarController.selectedIndex = 0;
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *)reader didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSLog(@"Authorization code detected");
    
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results) break;
    
    NSString *textFromCode = symbol.data;
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [self.model processAuthenticationCode:textFromCode];
    
    self.tabBarController.selectedIndex = 0;
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - AuthenticationModelDelegate

- (void)promptForAuthorization:(NSString *)realm
{
    
}

- (void)authorizationSent
{
    
}

- (void)authorizationFailed
{
    
}

@end
