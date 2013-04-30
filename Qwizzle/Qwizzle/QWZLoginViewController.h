//
//  QWZLoginViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/18/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface QWZLoginViewController : UIViewController <UITextFieldDelegate,ADBannerViewDelegate>

{

    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;
    // Handle iAd view
    ADBannerView *adView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property(nonatomic,retain) IBOutlet ADBannerView *adView; // handle banner componenet

- (IBAction)login:(id)sender;

@end
