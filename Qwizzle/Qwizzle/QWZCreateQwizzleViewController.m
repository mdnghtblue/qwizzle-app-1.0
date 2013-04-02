//
//  QWZCreateViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
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

@synthesize origin; // The origin's viewcontroller: it is needed to pass data back
@synthesize controlList;
@synthesize questionList;
@synthesize quizSet;

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

    // Krissada: Begin the dynamic part...
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
    [insertButton setTitle:@"Add more question"
                  forState:UIControlStateNormal];
    
    [insertButton setTag:50]; // For refenrencing: could any number
    [scrollView addSubview:insertButton];
    
    // Set content size of the scroll view to make it scrollable
    scrollviewWidth = 320;
    scrollviewHeight = 175;
    [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
}

// Dynamically add more UIView for questions
- (void)addMoreQuestion:(id)sender
{
    //NSLog(@"add more question!");
    //NSLog(@"Control count: %d, the max is %d", [controlList count], MAX_NUMBEROFQUESTIONS);
    
    if ([controlList count] < MAX_NUMBEROFQUESTIONS) { // If it's not on the limit, then add more questions
        
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
    }
    else { // Otherwise, display a warning and hide the button
        NSLog(@"NO more than %d mister!!", MAX_NUMBEROFQUESTIONS);
    }
}

// Krissada: createNewQuiz will create a new quiz, shoule check & validate every question here.
- (IBAction)submitAQwizzle:(id)sender
{
    NSLog(@"Submitting a Qwizzle, validation in process");
    
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
            NSLog(@"Question detected!: %@", [text copy]);
            [questionList addObject:[text copy]];
            
//            // Add hard-coded question set here
//            QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
//            QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your lastname?"];
//            
//            QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set"];
//            [qs1 addQuiz:q1];
//            [qs1 addQuiz:q2];
        }
    }
    
    if ([questionList count] == 0) {
        // All empty
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should add some question before you go." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSLog(@"questionList: %@", questionList);
        
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

- (IBAction)cancel:(id)sender
{
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

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
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
