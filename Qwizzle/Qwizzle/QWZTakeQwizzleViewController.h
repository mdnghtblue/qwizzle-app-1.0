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

@interface QWZTakeQwizzleViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;

    IBOutlet UIToolbar *toolbar;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property (nonatomic, strong) QWZAnsweredQuizSet *answeredQuizSet;

@property (weak, nonatomic) UIActionSheet *actionSheet;

- (IBAction)displayActionSheet:(id)sender;

- (IBAction)prepareToFillOutAQwizzle:(id)sender;

- (void)constructUI;

@end
