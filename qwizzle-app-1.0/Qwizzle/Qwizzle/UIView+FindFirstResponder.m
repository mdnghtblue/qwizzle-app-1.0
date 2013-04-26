//
//  UIView+FindFirstResponder.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/31/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

// This category finds and return the firstresponder
@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end
