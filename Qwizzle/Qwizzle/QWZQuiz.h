//
//  QWZQuiz.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QWZQuiz : NSObject
{
    
}

@property (nonatomic, retain) NSString *question; // Hold the question of the question
@property (nonatomic, retain) NSString *answer;   // Hold the answer of the question
@property (nonatomic, readonly, strong) NSDate *dateCreated;    // Hold the creation date of the question

// The designated initializer
- (id)initWithQuestion:(NSString *)question
                answer:(NSString *)answer;

- (id)initWithQuestion:(NSString *)question;

@end
