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
    int cellCount;
    ADBannerView *adView;
}
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet


- (IBAction)shareAQwizzle:(id)sender;

@end
