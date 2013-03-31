//
//  QWZCreateViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWZCreateQwizzleViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
}

- (IBAction)createNewQuiz:(id)sender;

@end
