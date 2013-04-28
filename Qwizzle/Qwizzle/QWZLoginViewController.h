//
//  QWZLoginViewController.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/18/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWZLoginViewController : UIViewController <UITextViewDelegate>
{
    
    NSInteger scrollviewWidth;
    NSInteger scrollviewHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;



- (IBAction)login:(id)sender;

@end
