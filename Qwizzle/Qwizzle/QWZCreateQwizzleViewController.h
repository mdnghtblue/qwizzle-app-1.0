//
//  QWZCreateViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QWZQwizzleViewController;
@class QWZQuizSet;

#define MAX_NUMBEROFQUESTIONS 5
#define KEYBOARD_OFFSET 115

@interface QWZCreateQwizzleViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
    // Storing coordinates for the dynamic part
    CGFloat x;
    CGFloat y;
    CGFloat textWidth;
    CGFloat textHeight;
    CGFloat fieldWidth;
    CGFloat fieldHeight;
    CGFloat fieldTextDistance;
    
    CGFloat buttonFormDistance;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
    CGFloat eachQuestionDistances;
    
    UIButton *insertButton;
    
    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;
    
    NSInteger tag;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin; // Store the origin's viewcontroller for submitting data back
@property (nonatomic, strong) NSMutableArray *questionList; // Store the questions that users actually filled out
@property (nonatomic, strong) NSMutableArray *controlList; // Store the dynamically created text fields
@property (nonatomic, strong) QWZQuizSet *quizSet; // Store the newly created quizSet (a Qwizzle)

// prepareToSubmitAQwizzle will create a new quiz, check & validate every question here
// Then will submit the quiz into the origin's viewcontroller.
- (IBAction)prepareToSubmitAQwizzle:(id)sender;

// Dismiss this page
- (IBAction)cancel:(id)sender;

// Dynamically add more UIView for questions
- (void)addMoreQuestion:(id)sender;

// This method was registered to the UITapGestureRecognizer
// To allow user to tap anywhere on the screen to dismiss the keyboard
- (void)dismissKeyboard;

@end
