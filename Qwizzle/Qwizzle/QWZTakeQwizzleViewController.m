//
//  QWZAnswerViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZTakeQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"

#import "UIView+FindFirstResponder.h"

@interface QWZTakeQwizzleViewController ()

@end

@implementation QWZTakeQwizzleViewController

@synthesize quizSet;
@synthesize controlList;
@synthesize answerList;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//        // Every viewcontroller has this navigationItem property
//        UINavigationItem *n = [self navigationItem];
//        [n setTitle:@"Answer Qwizzle"];
//    }
//    return self;
//}

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
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 250, 60)];
        [questionLabel setText:[[NSString alloc] initWithFormat:@"%@", qwzQuestion]];
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:questionLabel];
        
        // Adding the corresponding textfield for the first question
        UITextView *answerField = [[UITextView alloc] initWithFrame:CGRectMake(60, y + 50, 250, 60)];
        //[answerField s]
        [controlList addObject:answerField]; // We will need the reference later
        [scrollView addSubview:answerField];
        
        y += 100;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    UIView *view = [scrollView findFirstResponder];
    [view resignFirstResponder];
}

@end
