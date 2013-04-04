//
//  QWZAnswerViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
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
    
    // Preparing UI - Create and configure programmatically
    CGRect titleFrame = CGRectMake(40, 10, 250, 60);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"Taking Qwizzle:\n %@", [quizSet title]]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setNumberOfLines:2];
    [scrollView addSubview:titleLabel];
    
    NSInteger y = 100;
    for (NSInteger i = 0; i < [[quizSet allQuizzes] count]; i++)
    {
        NSString *qwzQuestion = [(QWZQuiz *)quizSet.allQuizzes[i] question];
        NSLog(@"question: %@", qwzQuestion);
        
        // Adding the text field for the question
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 250, 60)];
        [questionLabel setText:[[NSString alloc] initWithFormat:@"%@", qwzQuestion]];
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:questionLabel];
        
        // Adding the corresponding textfield for the first question
        UITextView *answerField = [[UITextView alloc] initWithFrame:CGRectMake(40, y + 50, 250, 60)];
        [answerField setScrollsToTop:true];
        answerField.layer.borderWidth = 2.0f;
        answerField.layer.borderColor = [[UIColor grayColor] CGColor];
        [controlList addObject:answerField]; // We will need the reference later
        [scrollView addSubview:answerField];
        
        y += 100;
    }
}

- (IBAction)fillOutAQwizzle:(id)sender
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
        
        // Submit a qwizzle to parents' viewcontroller
        [origin fillOutAQwizzle:answeredQuizSet];
        
        // Dismiss this view
        [self.navigationController popViewControllerAnimated:YES];
        //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
