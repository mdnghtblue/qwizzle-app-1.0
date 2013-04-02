//
//  QWZAnswerViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;

@interface QWZTakeQwizzleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}

- (void)dismissKeyboard;

// Hold a quiz set
@property (nonatomic, strong) QWZQuizSet *quizSet;

@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;

@end
