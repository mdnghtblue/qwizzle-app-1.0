//
//  QWZCreateViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZCreateQwizzleViewController.h"

@interface QWZCreateQwizzleViewController ()

@end

@implementation QWZCreateQwizzleViewController

// Krissada: We now do not need this since we switch to storyboard
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//        // Every viewcontroller has this navigationItem property
//        UINavigationItem *n = [self navigationItem];
//        [n setTitle:@"Create Qwizzle"];
//        
//        // Create a new bar button item that will send addNewItem: to QWZViewController
//        // UIBarButtonSystemItemSave is the default save button
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//                                                                             target:self
//                                                                             action:@selector(createNewQuiz:)];
//        
//        // Set this bar button item as the right item in the navigationItem
//        [[self navigationItem] setRightBarButtonItem:bbi];
//    }
//    return self;
//}

// Krissada: createNewQuiz will create a new quiz, shoule check & validate every question here.
- (IBAction)createNewQuiz:(id)sender
{
    
    //NSLog(@"Create New Quiz!! %@", [label text]);
    
    // Krissada: Use this if we use push segue
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

// Dynamically add more UIView for questions
- (void)addMoreQuestion:(id)sender
{
    NSLog(@"add more question!");
}

- (void)dismissKeyboard
{
    NSLog(@"dismiss");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    // Preparing UI
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    
    UITextField *taskField;
    UIButton *insertButton;
    
    // Create and configure a text field programmatically
    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
    [taskField setPlaceholder:@"Type your question"];
    [taskField setDelegate:self];
    
    // Create and configure a rounded rect button
    insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [insertButton setFrame:buttonFrame];
    
    // Buttons behave using a target/action callback
    // Configue the insert button's action to call this object's method
    [insertButton addTarget:self
                     action:@selector(addMoreQuestion:)
           forControlEvents:UIControlEventTouchUpInside];
    
    // Give the button a title (Adding more question)
    [insertButton setTitle:@"Add more question"
                  forState:UIControlStateNormal];

    [scrollView addSubview:taskField];
    [scrollView addSubview:insertButton];
    
//    fieldFrame = CGRectMake(20, 140, 200, 31);
//    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
//    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
//    [taskField setPlaceholder:@"Type your question"];
//    [taskField setDelegate:self];
//    [scrollView addSubview:taskField];
//    
//    fieldFrame = CGRectMake(20, 240, 200, 31);
//    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
//    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
//    [taskField setPlaceholder:@"Type your question"];
//    [taskField setDelegate:self];
//    [scrollView addSubview:taskField];
//    
//    fieldFrame = CGRectMake(20, 340, 200, 31);
//    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
//    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
//    [taskField setPlaceholder:@"Type your question"];
//    [taskField setDelegate:self];
//    [scrollView addSubview:taskField];
//    
//    fieldFrame = CGRectMake(20, 440, 200, 31);
//    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
//    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
//    [taskField setPlaceholder:@"Type your question"];
//    [taskField setDelegate:self];
//    [scrollView addSubview:taskField];
    
    [scrollView setContentSize:CGSizeMake(320, 480)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
