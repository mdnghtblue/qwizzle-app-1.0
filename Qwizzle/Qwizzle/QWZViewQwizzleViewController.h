//
//  QWZViewAnswerViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;

#define OFFSET 40

@interface QWZViewQwizzleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}

// Hold a quiz set
@property (nonatomic, strong) QWZQuizSet *quizSet;

@end
