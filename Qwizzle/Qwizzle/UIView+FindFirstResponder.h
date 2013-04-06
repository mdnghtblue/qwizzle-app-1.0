//
//  UIView+FindFirstResponder.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/31/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

// This category finds and return the firstresponder
@interface UIView (FindFirstResponder)

- (UIView *)findFirstResponder;

@end
