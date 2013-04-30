//
//  QWZViewQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@class QWZQuizSet;

@interface QWZViewQwizzleViewController : UIViewController<ADBannerViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    ADBannerView *adView;
}

// Hold a quiz set
@property (nonatomic, strong) QWZQuizSet *quizSet;

@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet


- (void)constructUI;

- (void)fetchesAnswers:(QWZQuizSet *)qz;

@end
