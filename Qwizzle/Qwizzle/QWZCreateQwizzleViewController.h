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

#define MAX_NUMBEROFQUESTIONS 20
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

- (IBAction)prepareToSubmitAQwizzle:(id)sender;
- (void)addMoreQuestion:(id)sender;
- (void)dismissKeyboard;

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *questionList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;

@end
