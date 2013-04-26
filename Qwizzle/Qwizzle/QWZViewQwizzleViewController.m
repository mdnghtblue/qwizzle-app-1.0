//
//  QWZViewQwizzleViewController.m
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
    
    NSLog(@"QWZViewQwizzleViewController with a quizset %@", [quizSet title]);
    NSLog(@"This quizset has %d questions", [[quizSet allQuizzes] count]);
    
    // For each quiz
    QWZQuiz *quiz;
    CGFloat latestPosition; // the latest position for a ui element
    CGFloat latestHeight; // the latest height of a ui element
    CGSize labelSize; // stores label's height
    
    CGRect titleFrame = CGRectMake(40, 10, 250, 60);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"%@", [quizSet title]]];
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
    UILabel *label;
    for (NSInteger i = 0; i < [[quizSet allQuizzes] count]; i++) {
        quiz = [[quizSet allQuizzes] objectAtIndex:i];
        
        // Move the next question's text a little bit
        latestPosition = latestHeight + OFFSET;
        
        // Preparing a label for a question
        CGRect labelFrame = CGRectMake(QUIZSET_HORIZONTAL_POS, latestPosition, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT);
        
        // Create the new label and assign values to the necessary fields
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
        
        latestHeight = labelSize.height + latestPosition;
        [scrollView addSubview:label];
        
        // Move the UI element's position according to the lastest height of the textfield
        // and the offset between question and answer
        latestPosition = latestHeight + QUESTION_ANSWER_OFFSET; // Move just a little bit
        
        labelFrame = CGRectMake(QUIZSET_HORIZONTAL_POS, latestPosition, QUIZSET_ITEM_WIDTH, QUIZSET_ITEM_HEIGHT);
        
        // Create the new label and assign values to the necessary fields
        label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setText:[[NSString alloc] initWithFormat:@"%@", [quiz answer]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label sizeToFit];
        
        labelSize = [label.text sizeWithFont:label.font
                           constrainedToSize:label.frame.size
                               lineBreakMode:NSLineBreakByWordWrapping];
        latestHeight = labelSize.height + latestPosition;

        [scrollView addSubview:label];
    }
    
    [scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, latestHeight + OFFSET)];
}

// Implement this method if there is anything needed to be done if we receive a memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
