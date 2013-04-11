//
//  QWZTakeQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;
@class QWZAnsweredQuizSet;
@class QWZQwizzleViewController;

#define KEYBOARD_OFFSET 115
#define SCROLL_VIEW_WIDTH 320
#define SCROLL_VIEW_HEIGHT 175
#define QUIZSET_VERTICAL_OFFSET 100
#define ANSWER_VERTICAL_OFFSET 50
#define QUESTION_DISTANCES 135
#define QUIZSET_HORIZONTAL_POS 40
#define QUIZSET_ITEM_WIDTH 250
#define QUIZSET_ITEM_HEIGHT 60

@interface QWZTakeQwizzleViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property (nonatomic, strong) QWZAnsweredQuizSet *answeredQuizSet;

- (IBAction)prepareToFillOutAQwizzle:(id)sender;


@end
