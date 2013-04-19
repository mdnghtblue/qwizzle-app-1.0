//
//  QWZLoginViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/18/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZLoginViewController.h"

#import "QWZQwizzleStore.h"
#import "QWZQwizzle.h"

@interface QWZLoginViewController ()

@end

@implementation QWZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender
{
    // Suppose the login was successful, set this parameter as an indication and dismiss this view
    // Otherwise, the user can't use this app and stay in this login view.
    // In the future, we might provide the register button in this view that allow user to actually register for an account
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Krissada" forKey:@"username"];
    
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
