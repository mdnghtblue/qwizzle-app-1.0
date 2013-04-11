//
//  QWZTakeQwizzleViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "QWZQwizzleViewController.h"
#import "QWZTakeQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"

#import "UIView+FindFirstResponder.h"

@interface QWZTakeQwizzleViewController ()

@end

@implementation QWZTakeQwizzleViewController

@synthesize origin; // The origin's viewcontroller: it is needed to pass data back
@synthesize quizSet;
@synthesize controlList;
@synthesize answerList;
@synthesize answeredQuizSet;

// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"QWZTakeQwizzleViewController with a quizset %@", [quizSet title]);
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    controlList = [[NSMutableArray alloc] init];
    answerList = [[NSMutableArray alloc] init];
    
    // Set the initial content size of the scroll view to make it scrollable

    [scrollView setContentSize:CGSizeMake(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT)];
    
    // Preparing UI - Create and configure programmatically
    CGRect titleFrame = CGRectMake(40, 10, 250, 60);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"Taking Qwizzle:\n %@", [quizSet title]]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setNumberOfLines:2];
    [scrollView addSubview:titleLabel];
    
    NSInteger y = QUIZSET_VERTICAL_OFFSET; // initial vertical position for question set
    for (NSInteger i = 0; i < [[quizSet allQuizzes] count]; i++)
    {
        NSString *qwzQuestion = [(QWZQuiz *)quizSet.allQuizzes[i] question];
        NSLog(@"question: %@", qwzQuestion);
        
        // Adding the text field for the question
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(QUIZSET_HORIZONTAL_POS, y, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT)];
        [questionLabel setText:[[NSString alloc] initWithFormat:@"%@", qwzQuestion]];
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:questionLabel];
        
        // Adding the corresponding textfield for the first question
        UITextView *answerField = [[UITextView alloc] initWithFrame:CGRectMake(QUIZSET_HORIZONTAL_POS, y + ANSWER_VERTICAL_OFFSET, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT)];
        [answerField setScrollsToTop:true];
        [answerField setDelegate:self];
        answerField.layer.borderWidth = 2.0f;
        answerField.layer.borderColor = [[UIColor grayColor] CGColor];
        [controlList addObject:answerField]; // We will need the reference later
        [scrollView addSubview:answerField];
        
        y += QUIZSET_VERTICAL_OFFSET;
        
        scrollviewHeight = scrollviewHeight + QUESTION_DISTANCES;
        [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
    }
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

// This method performs any actions necessary to process taking a qwizzle before returning control to the root view controller
- (IBAction)prepareToFillOutAQwizzle:(id)sender
{
    NSLog(@"Submitting qwizzle answers....");
    
    // Validate code may go here
    NSInteger emptyCount = 0;
    for (NSInteger i = 0; i < [controlList count]; i++) {
        NSLog(@"%d of %d) %@", i, [controlList count], [[controlList objectAtIndex:i] text]);
        
        NSString *text = [[controlList objectAtIndex:i] text];
        if (text == nil || [text isEqualToString:@""]) {
            NSLog(@"Empty cell detected!");
            emptyCount++;
        }
        else {
            NSLog(@"Answer detected!: %@", [text copy]);
            [answerList addObject:[text copy]];
        }
    }
    
    if ([answerList count] == 0) {
        // All empty
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should fill out some answers before you go." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSLog(@"answerList: %@", answerList);
        
        answeredQuizSet = [[QWZAnsweredQuizSet alloc] initWithTitle:[quizSet title]];
        for (NSInteger i = 0; i < [answerList count]; i++) {
            // Add a new item to the answered quiz set with the original question and the given answer
            NSLog(@"getting the question: %@", [[[quizSet allQuizzes] objectAtIndex:i] question]);
            [answeredQuizSet addQuiz:[[QWZQuiz alloc] initWithQuestion:[[[quizSet allQuizzes] objectAtIndex:i] question] answer:[answerList objectAtIndex:i]]];
        }
        
        // Submit a qwizzle to parents' view controller
        [origin fillOutAQwizzle:answeredQuizSet];
        
        // Dismiss this view
        [self.navigationController popViewControllerAnimated:YES];
    }
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

// Implement this method if there is anything needed to be done if we receive a memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
