//
//  QWZViewQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;

#define OFFSET 40
#define QUESTION_HORIZONTAL_POS 20
#define ANSWER_HORIZONTAL_POS 40
#define QUIZSET_ITEM_WIDTH 250
#define QUIZSET_ITEM_HEIGHT 30
#define SCROLLVIEW_WIDTH 320
#define SCROLLVIEW_HEIGHT_OFFSET 20

@interface QWZViewQwizzleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}

// Hold a quiz set
@property (nonatomic, strong) QWZQuizSet *quizSet;

@end
