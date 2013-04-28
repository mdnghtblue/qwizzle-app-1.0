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
    //setting the interface
    self.titleLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title"]];
    self.viewController.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    // Do any additional setup after loading the view from its nib.

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
   
    
}

- (IBAction)login:(id)sender
{
    // Suppose the login was successful, set this parameter as an indication and dismiss this view
    // Otherwise, the user can't use this app and stay in this login view.
    // In the future, we might provide the register button in this view that allow user to actually register for an account
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // [defaults setObject:@"2" forKey:@"user_id"];
    
    NSString *userName= userNameText.text;
    NSString *password=passwordText.text;
    
    // The codeblock to run after finish loading the connection
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        // Replaces the activity indicator with the previous title
     
        
        if (!err) {
            // If everything went ok (with no error), grab the object, and reload the table
         
          
            NSString *status = [[obj JSON] objectForKey:@"status"];
           
            if ([status isEqualToString:@"success"]) {
                
            NSLog(@"loging for user:%@",[[obj JSON] objectForKey:@"user_id"]);
          

            
                 [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

                
            }
            
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore]fetchUserWithUsername:userName andPassword:password WithCompletion:completionBlock];
    
   
   }

// Implement this method if there is anything needed to be configured before the view appears on the screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

        [self registerForKeyboardNotifications];
}

// Implement this method if there is anything needed to be configured before the view disappears on the screen
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotifications];
}

#pragma mark handling keyboard
// Call this method to register for all keyboard appearance notifications
- (void)registerForKeyboardNotifications
{
    NSLog(@"Registering for Keyboard Notification");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Call this method to remove all keyboard appearance notifications
- (void)removeKeyboardNotifications
{
    NSLog(@"Removeing for Keyboard Notification");
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Getting the keyboard's size
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Getting the scrollView's height and add it with the keyboard's height
    scrollviewHeight += keyboardSize.height;
    
    // Make the scrollView bigger
    [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Getting the keyboard's size
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Getting the scrollView's height and add it with the keyboard's height
    scrollviewHeight -= keyboardSize.height;
    
    // Make the scrollView bigger
    [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
}


//Called when the user is beginning to edit a text field
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Get the current origin of the textfield
    CGPoint point = textView.frame.origin ;
    point.x = 0;
    point.y = point.y - KEYBOARD_OFFSET; // adjust the position just to accommodate the keyboard
    [scrollView setContentOffset:point animated:YES]; // Move the scrollView to the position
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

@end
