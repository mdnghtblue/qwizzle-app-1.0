//
//  QWZViewAnswerViewController.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZViewQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"

@interface QWZViewQwizzleViewController ()

@end

@implementation QWZViewQwizzleViewController

@synthesize quizSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"QWZViewQwizzleViewController with a quizset %@", [quizSet title]);
    //NSLog(@"This quizset have %d questions", [[quizSet allQuizzes] count]);
    
    // For each quiz
    QWZQuiz *quiz;
    CGFloat position;
    CGFloat latestHeight;
    UILabel *label;
    for (NSInteger i = 0; i < [[quizSet allQuizzes] count]; i++) {
        quiz = [[quizSet allQuizzes] objectAtIndex:i];
        
        if (i == 0) { // Set initial position
            position = (i + 1) * OFFSET;
        }
        else { // Otherwise, set the position by the latest bound
            position = latestHeight + OFFSET;
        }
        
        //////// Preparing a label for a question
        
        CGRect labelFrame = CGRectMake(20, position, 250, 30);
        label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setText:[[NSString alloc] initWithFormat:@"%d.) %@", (i + 1), [quiz question]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label sizeToFit];
        
        // Getting the label's height
        CGSize labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:label.frame.size
                                      lineBreakMode:NSLineBreakByWordWrapping];
        latestHeight = labelSize.height + position;
        [scrollView addSubview:label];

        //////// Preparing the label for an answer
        
        position = latestHeight + 10; // Move just a little bit
        labelFrame = CGRectMake(40, position, 250, 30);
        label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setText:[[NSString alloc] initWithFormat:@"%@", [quiz answer]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label sizeToFit];
        
        labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:label.frame.size
                                      lineBreakMode:NSLineBreakByWordWrapping];
        latestHeight = labelSize.height + position;

        [scrollView addSubview:label];
        
        NSLog(@"question: %@ - answer %@", [quiz question], [quiz answer]);
    }
    
    [scrollView setContentSize:CGSizeMake(320, latestHeight + 20)];
    //for (QWZQuiz *quiz in [quizSet allQuizzes]) {
        
    //}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
