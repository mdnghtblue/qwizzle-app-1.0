//
//  UIView+FindFirstResponder.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/31/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

// Krissada: This category finds and return the firstresponder
// 
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
