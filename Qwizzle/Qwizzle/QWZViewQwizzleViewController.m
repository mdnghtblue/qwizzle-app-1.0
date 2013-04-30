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

#import "QWZQwizzleStore.h"
#import "JSONContainer.h"

@interface QWZViewQwizzleViewController ()

@end

@implementation QWZViewQwizzleViewController

@synthesize quizSet;

@synthesize adView; // handle iAd

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting the iAd
    adView.delegate=self;
    [adView setHidden:YES]; // setting the defualt behvior for iAd
    

    self.navigationController.toolbarHidden = YES;
    
    NSLog(@"QWZViewQwizzleViewController with a quizset %@", [quizSet title]);
    NSLog(@"This quizset has %d questions", [[quizSet allQuizzes] count]);
    
    [quizSet removeAllQuizzes];
    
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
            
            [self fetchesAnswers:quizSet];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] fetchQuestions:[quizSet quizSetID] WithCompletion:completionBlock];
}

- (void)fetchesAnswers:(QWZQuizSet *)qz
{
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
            
            NSMutableArray *answers = [[obj JSON] objectForKey:@"answers"];
            NSString *answer = nil;
            for (int i = 0; i < [answers count]; i++) {
                answer = [[answers objectAtIndex:i] objectForKey:@"answer"];
                [[[qz allQuizzes] objectAtIndex:i] setAnswer:answer];
            }
            
            // Construct the UI
            [self constructUI];
        } else {
            // If things went bad, show an alert view to users
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }; // Finish declaring a code block to run after finish running the connection
    
    [[QWZQwizzleStore sharedStore] fetchAnswers:[quizSet quizSetID] WithCompletion:completionBlock];
}

- (void)constructUI
{
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
#pragma mark iAd view
// Implement this method if iAd is load to be set only if it has adv
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [adView setHidden:NO]; // show iAd view when avialble
    NSLog(@"iAd showing");
    
    
}
// Implement this method if there is an error for governer Ad
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [adView setHidden:YES]; // hide iAd when there is an error
    NSLog(@"iAd is hidden");
}

@end
