//
//  QWZQwizzle.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface QWZQwizzle : NSObject <JSONSerializable>
{
    // This array stores all quiz sets
    NSMutableArray *allQuizSets;
    
    // This array stores all answered quiz sets
    NSMutableArray *allAnsweredQuizSets;
}

- (void)generateSampleData;

@end
