//
//  QWZShareQwizzleViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@class QWZQuizSet;

@interface QWZShareQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate>
{
    int cellCount; // Still hard-coded for controlling the friend list - For the future releases
    ADBannerView *adView;
}
@property (nonatomic, strong) QWZQuizSet *quizSet; // Hold the qwizzle to be shared
@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet

// Initiate sharing, called when the user hit the share button
- (IBAction)shareAQwizzle:(id)sender;

@end
