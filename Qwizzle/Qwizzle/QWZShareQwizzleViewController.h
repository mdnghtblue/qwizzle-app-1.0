//
//  QWZShareQwizzleViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QWZQuizSet;

@interface QWZShareQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QWZQuizSet *quizSet;

- (IBAction)shareAQwizzle:(id)sender;

@end
