//
//  QWZCreateQwizzleViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZCreateQwizzleViewController.h"
#import "QWZQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"

#import "UIView+FindFirstResponder.h"

@interface QWZCreateQwizzleViewController ()

@end

@implementation QWZCreateQwizzleViewController

@synthesize origin; // Store the origin's viewcontroller for submitting data back
@synthesize questionList; // Store the questions that users actually filled out
@synthesize controlList; // Store the dynamically created text fields
@synthesize quizSet; // Store the newly created quizSet (a Qwizzle)

// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    // Preparing UI - Create and configure programmatically
    CGRect titleFrame = CGRectMake(20, 40, 50, 30);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"Title:"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:titleLabel];
    
    CGRect fieldFrame = CGRectMake(70, 40, 230, 30);
    UITextField *titleField= [[UITextField alloc] initWithFrame:fieldFrame];
    [titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [titleField setPlaceholder:@"Title for your Qwizzle"];
    [titleField setDelegate:self];
    [titleField setTag:25]; // For refenrencing: could any number
    [scrollView addSubview:titleField];

    // Beginning the dynamic part...
    x = 20;
    y = 85;
    textWidth = 25;
    textHeight = 30;
    fieldWidth = 255;
    fieldHeight = textHeight;
    fieldTextDistance = 25;
    
    buttonWidth = 280;
    buttonHeight = 40;
    buttonFormDistance = 40;
    
    eachQuestionDistances = 45;
    
    controlList = [[NSMutableArray alloc] init];
    questionList = [[NSMutableArray alloc] init];
    
    // Adding the first textfield for the first question
    CGRect numberBulletFrame = CGRectMake(x, y, textWidth, textHeight);
    UILabel *numberBulletLabel = [[UILabel alloc] initWithFrame:numberBulletFrame];
    [numberBulletLabel setText:[[NSString alloc] initWithFormat:@"%d.", ([controlList count] + 1)]];
    [numberBulletLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:numberBulletLabel];
    
    // Adding the corresponding textfield for the first question
    CGRect questionFrame = CGRectMake((x + fieldTextDistance), y, fieldWidth, fieldHeight);
    UITextField *questionField = [[UITextField alloc] initWithFrame:questionFrame];
    [questionField setBorderStyle:UITextBorderStyleRoundedRect];
    [questionField setPlaceholder:@"What's your question?"];
    [questionField setDelegate:self];
    [controlList addObject:questionField]; // We will need the reference later
    [scrollView addSubview:questionField];
    
    // Adding the add more question button
    CGRect buttonFrame = CGRectMake(x, (y + buttonFormDistance), buttonWidth, buttonHeight);
    insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [insertButton setFrame:buttonFrame];
    [insertButton addTarget:self
                     action:@selector(addMoreQuestion:)
           forControlEvents:UIControlEventTouchUpInside];
    [insertButton setTitle:@"Add another question"
                  forState:UIControlStateNormal];
    
    [insertButton setTag:50]; // For referencing: could be any number
    [scrollView addSubview:insertButton];
    
    // Set the content size of the scroll view to make it scrollable
    scrollviewWidth = 320;
    scrollviewHeight = 175;
    [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
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

// Dynamically add more UIView for questions
- (void)addMoreQuestion:(id)sender
{
    [self dismissKeyboard];
    
    // If it does not reach the limit, then add more questions
    if ([controlList count] < MAX_NUMBEROFQUESTIONS) { 
        // Adjust the distance between controls
        y = y + eachQuestionDistances;

        // Add the controls
        CGRect numberBulletFrame = CGRectMake(x, y, textWidth, textHeight);
        UILabel *numberBulletLabel = [[UILabel alloc] initWithFrame:numberBulletFrame];
        [numberBulletLabel setText:[[NSString alloc] initWithFormat:@"%d.", ([controlList count] + 1)]];
        [numberBulletLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:numberBulletLabel];
        
        CGRect questionFrame = CGRectMake((x + fieldTextDistance), y, fieldWidth, fieldHeight);
        UITextField *questionField = [[UITextField alloc] initWithFrame:questionFrame];
        [questionField setBorderStyle:UITextBorderStyleRoundedRect];
        [questionField setPlaceholder:@"What's your question?"];
        [questionField setDelegate:self];
        [controlList addObject:questionField]; // We will need the reference later
        [scrollView addSubview:questionField];
        
        // Adjust the position of the add more question button
        CGRect newButtonFrame = CGRectMake(x, (y + buttonFormDistance), buttonWidth, buttonHeight);
        [[scrollView viewWithTag:50] setFrame:newButtonFrame];
        
        scrollviewHeight = scrollviewHeight + eachQuestionDistances;
        [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
        
        // If the number of control reached the maximum number defined, hide the add more button
        if ([controlList count] == MAX_NUMBEROFQUESTIONS) {
            [[scrollView viewWithTag:50] setHidden:YES];
            
            CGRect warningFrame = [[scrollView viewWithTag:50] frame];
            UILabel *warningLabel = [[UILabel alloc] initWithFrame:warningFrame];
            [warningLabel setText:[[NSString alloc] initWithFormat:@"The maximun of %d questions reached", MAX_NUMBEROFQUESTIONS]];
            [warningLabel setBackgroundColor:[UIColor clearColor]];
            [scrollView addSubview:warningLabel];
        }
    }
    else { // Otherwise, display a warning and hide the button
        NSLog(@"No more than %d, Mister!!", MAX_NUMBEROFQUESTIONS);
    }
}

// prepareToSubmitAQwizzle will create a new quiz, check & validate every question here
// Then will submit the quiz into the origin's viewcontroller.
- (IBAction)prepareToSubmitAQwizzle:(id)sender
{
    NSLog(@"Submitting a Qwizzle, validation in process");
    
    // Validate code may go here
    NSInteger emptyCount = 0;
    for (NSInteger i = 0; i < [controlList count]; i++) {
        NSString *text = [[controlList objectAtIndex:i] text];
        if (text == nil || [text isEqualToString:@""]) {
            NSLog(@"Empty cell detected!");
            emptyCount++;
        }
        else {
            NSLog(@"Question detected!: %@", [text copy]);
            [questionList addObject:[text copy]];
        }
    }
    
    if ([questionList count] == 0) {
        // It's all empty, show some alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should add some question before you go." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UITextField *title = (UITextField *)[scrollView viewWithTag:25];
        NSString *titleText = [title text];
        if (titleText == nil || [titleText isEqualToString:@""]) {
            quizSet = [[QWZQuizSet alloc] init];
        }
        else {
            quizSet = [[QWZQuizSet alloc] initWithTitle:[titleText copy]];
        }
        
        for (NSInteger i = 0; i < [questionList count]; i++) {
            [quizSet addQuiz:[[QWZQuiz alloc] initWithQuestion:[questionList objectAtIndex:i]]];
        }
        
        // Submit a qwizzle to parents' viewcontroller
        [origin submitAQwizzle:quizSet];
        
        // Dismiss this view
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

// Called if the user tap the calcel button on the navigation bar
- (IBAction)cancel:(id)sender
{
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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

// Called when the user is beginning to edit a text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Get the current origin of the textfield
    CGPoint point = textField.frame.origin ;
    point.x = 0;
    point.y = point.y - KEYBOARD_OFFSET; // adjust the position just to accommodate the keyboard
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

// Implement this method if there is anything needed to be done if we receive a memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
