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

#import "QWZQwizzleStore.h"
#import "JSONContainer.h"

#import "QWZShareQwizzleViewController.h"

@interface QWZTakeQwizzleViewController ()

@end

@implementation QWZTakeQwizzleViewController

@synthesize origin; // The origin's viewcontroller: it is needed to pass data back
@synthesize quizSet;
@synthesize controlList;
@synthesize answerList;
@synthesize answeredQuizSet;

@synthesize actionSheet = _actionSheet;

// Implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"QWZTakeQwizzleViewController with a quizset %@", [quizSet title]);
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    [quizSet removeAllQuizzes];
    
    controlList = [[NSMutableArray alloc] init];
    answerList = [[NSMutableArray alloc] init];
    
    // Start preparing to get all the questions of this quizset
    // Prepare to connect to the web service
    // Get ahold of the segmented control that is currently in the title view
    UIView *currentTitleView = [[self navigationItem] titleView];
    
    // Create an activity indicator while loading
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    // The codeblock to run after finish loading the connection
    void (^completionBlock)(JSONContainer *obj, NSError *err) = ^(JSONContainer *obj, NSError *err) {
        
        // Replaces the activity indicator with the previous title
        [[self navigationItem] setTitleView:currentTitleView];
        
        if (!err) {
            // If everything went ok (with no error), grab all questions and construct all the UI
            
            QWZQuiz *qz = nil;
            NSDictionary *question = nil;
            NSArray *questions = [[obj JSON] objectForKey:@"questions"];
            for (int i = 0; i < [questions count]; i++) {
                question = [[questions objectAtIndex:i] objectForKey:@"question"];
                qz = [[QWZQuiz alloc] initWithID:[[question objectForKey:@"id"] intValue] question:[[question objectForKey:@"text"] copy] andAnswer:@""];
                
                [quizSet addQuiz:qz];
            }
            
            // Construct the UI
            [self constructUI];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] fetchQuestions:[quizSet quizSetID] WithCompletion:completionBlock];
}

- (void)constructUI
{
    // Set the initial content size of the scroll view to make it scrollable
    [scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    
    // Preparing UI - Create and configure programmatically
    CGFloat latestPosition; // the latest position for a ui element
    CGFloat latestHeight; // the latest height of a ui element
    CGSize labelSize; // stores label's height
    
    CGRect titleFrame = CGRectMake(40, 10, 250, 60);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"Taking Qwizzle:\n %@", [quizSet title]]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    // Fix multiple lines issue of those long questions.
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel sizeToFit];
    labelSize = [titleLabel.text sizeWithFont:titleLabel.font
                            constrainedToSize:titleLabel.frame.size
                                lineBreakMode:NSLineBreakByWordWrapping];
    latestPosition = titleFrame.origin.y;
    latestHeight = labelSize.height + latestPosition;
    [scrollView addSubview:titleLabel];

    // Begin the dynamic parts
    for (NSInteger i = 0; i < [[quizSet allQuizzes] count]; i++)
    {
        NSString *qwzQuestion = [(QWZQuiz *)quizSet.allQuizzes[i] question];
        
        // Move the next question's text a little bit
        latestPosition = latestHeight + OFFSET;

        // Adding the text field for the question
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(QUIZSET_HORIZONTAL_POS, latestPosition, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT)];
        
        [questionLabel setText:[[NSString alloc] initWithFormat:@"%d.) %@", (i + 1), qwzQuestion]];
        [questionLabel setBackgroundColor:[UIColor clearColor]];

        // Fix multiple lines issue of those long questions.
        [questionLabel setNumberOfLines:0];
        [questionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [questionLabel sizeToFit];
        CGSize labelSize = [questionLabel.text sizeWithFont:questionLabel.font
                           constrainedToSize:questionLabel.frame.size
                               lineBreakMode:NSLineBreakByWordWrapping];
        
        latestHeight = labelSize.height + latestPosition;
        [scrollView addSubview:questionLabel];
        
        // Move the UI element's position according to the lastest height of the textfield
        // and the offset between question and answer
        latestPosition = latestHeight + QUESTION_ANSWER_OFFSET; 
        
        // Adding the corresponding textfield for the first question
        UITextView *answerField = [[UITextView alloc] initWithFrame:CGRectMake(QUIZSET_HORIZONTAL_POS, latestPosition, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT)];
        [answerField setScrollsToTop:true];
        [answerField setDelegate:self];
        answerField.layer.borderWidth = 2.0f;
        answerField.layer.borderColor = [[UIColor grayColor] CGColor];
        [controlList addObject:answerField]; // We will need the reference later
        [scrollView addSubview:answerField];
        
        latestHeight = latestPosition + QUIZSET_ITEM_HEIGHT;
    }
    scrollviewHeight = latestHeight + OFFSET; // 20px is a minor adjustment of margin at the bottom of the screen
    
    [scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, scrollviewHeight)];
}

- (IBAction)displayActionSheet:(id)sender
{
    NSLog(@"displayActionSheet");
    if (self.actionSheet) {
        // do nothing
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share This Qwizzle", nil];
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

// A delegate method that handle actionsheet action
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // destroy something, never happen because we did not provide any destructive button
        NSLog(@"Destroy");
    } else if ([choice isEqualToString:@"Share This Qwizzle"]){
        // do something else
        NSLog(@"Share this qwizzle!");
        [self performSegueWithIdentifier:@"SEGUEShareQwizzle" sender:self];
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
        
        QWZQuiz *qz = nil;
        answeredQuizSet = [[QWZAnsweredQuizSet alloc] initWithTitle:[quizSet title] andID:[quizSet quizSetID]];
        
        for (NSInteger i = 0; i < [answerList count]; i++) {
            // Add a new item to the answered quiz set with the original question and the given answer
            NSLog(@"getting the question (id=%d): %@", [[[quizSet allQuizzes] objectAtIndex:i] questionID], [[[quizSet allQuizzes] objectAtIndex:i] question]);
            
            qz = [[QWZQuiz alloc] initWithID:[[[quizSet allQuizzes] objectAtIndex:i] questionID] question:[[[quizSet allQuizzes] objectAtIndex:i] question] andAnswer:[answerList objectAtIndex:i]];
            
            [answeredQuizSet addQuiz:qz];
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

// This method get called automatically when we're moving to the other view in the storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"SEGUEShareQwizzle"])
    {
        // Get the destination's view controller (User is taking a Qwizzle)
        QWZShareQwizzleViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setQuizSet:quizSet];
    }
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
