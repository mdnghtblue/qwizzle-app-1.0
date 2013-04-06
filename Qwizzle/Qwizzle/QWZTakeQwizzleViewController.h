//
//  QWZAnswerViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;
@class QWZAnsweredQuizSet;
@class QWZQwizzleViewController;

@interface QWZTakeQwizzleViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property (nonatomic, strong) QWZAnsweredQuizSet *answeredQuizSet;

- (IBAction)fillOutAQwizzle:(id)sender;


@end
