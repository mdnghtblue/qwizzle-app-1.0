//
//  QWZTakeQwizzleViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@class QWZQuizSet;
@class QWZAnsweredQuizSet;
@class QWZQwizzleViewController;

@interface QWZTakeQwizzleViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate,ADBannerViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;

    IBOutlet UIToolbar *toolbar;
    
     ADBannerView *adView;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property (nonatomic, strong) QWZAnsweredQuizSet *answeredQuizSet;

@property (weak, nonatomic) UIActionSheet *actionSheet;
@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet


- (IBAction)displayActionSheet:(id)sender;

- (IBAction)prepareToFillOutAQwizzle:(id)sender;

- (void)constructUI;

@end
