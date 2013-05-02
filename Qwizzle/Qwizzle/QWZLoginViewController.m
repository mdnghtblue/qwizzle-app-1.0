//
//  QWZLoginViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/18/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.

#import "QWZLoginViewController.h"

#import "QWZQwizzleStore.h"
#import "JSONContainer.h"

#import "UIView+FindFirstResponder.h"
#define KEYBOARD_OFFSET 115
#define SCROLL_VIEW_WIDTH 320
#define SCROLL_VIEW_HEIGHT 175

@interface QWZLoginViewController ()

@end

@implementation QWZLoginViewController

@synthesize scrollView;
@synthesize userNameText;
@synthesize passwordText;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // setting the iAd
    adView.delegate=self;
    [adView setHidden:YES]; // setting the defualt behvior for iAd
    
    //setting the interface
    self.titleLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title"]];
    self.viewController.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    // Do any additional setup after loading the view from its nib.

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"viewDidLoad - user info:%@",[defaults objectForKey:@"user_id"]);
}

- (IBAction)login:(id)sender
{
    NSString *userName= userNameText.text;
    NSString *password=passwordText.text;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // The codeblock to run after finish loading the connection
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!err) {
            // If everything went ok (with no error), grab the object, and reload the table
         
          
            NSString *status = [[obj JSON] objectForKey:@"status"];
           
            if ([status isEqualToString:@"success"]) {
                
            NSLog(@"loging for user:%@ (%@)", [[obj JSON] objectForKey:@"user_name"], [[obj JSON] objectForKey:@"user_id"]);
          
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *userID = [[NSString alloc] initWithFormat:@"%d", [[[obj JSON] objectForKey:@"user_id"] intValue]];
                NSString *userName = [[NSString alloc] initWithFormat:@"%@", [[obj JSON] objectForKey:@"user_name"]];
                 [defaults setObject:[userID copy] forKey:@"user_id"];
                [defaults setObject:[userName copy] forKey:@"user_name"];
            NSLog(@"user info:%@",[defaults objectForKey:@"user_id"]);
                 [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"user_id"];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Information" message:@"Wrong username and password combination. please retry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
            
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore]fetchUserWithUsername:userName andPassword:password WithCompletion:completionBlock];
    
   
}

// Called when the user is beginning to edit a text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Get the current origin of the textfield
    CGPoint point = textField.frame.origin ;
    point.x = 0;
    point.y = 75; // adjust the position just to accommodate the keyboard
    [scrollView setContentOffset:point animated:YES]; // Move the scrollView to the position
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Get the current origin of the textfield
    CGPoint point = textField.frame.origin ;
    point.x = 0;
    point.y = 25; // adjust the position just to accommodate the keyboard
    [scrollView setContentOffset:point animated:YES]; // Move the scrollView to the position
}

// The system will call this method to see whether a text field should return and dismiss the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// This method was registered to the UITapGestureRecognizer
// To allow user to tap anywhere on the screen to dismiss the keyboard
- (void)dismissKeyboard
{
    UIView *view = [scrollView findFirstResponder];
    [view resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark iAd view
// Implement this method if iAd is load to be set only if it has adv
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [adView setHidden:NO]; // show iAd view when avialble
    NSLog(@"iAd showing");
    
    
}
// Implement this method if there is an error for governer Ad
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [adView setHidden:YES]; // hide iAd when there is an error
    NSLog(@"iAd is hidden");
}


@end
