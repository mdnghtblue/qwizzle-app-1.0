//
//  QWZAnsweredQuizSet.h
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWZQuizSet.h"

@interface QWZAnsweredQuizSet : QWZQuizSet

@property (nonatomic) NSInteger creatorID;    // Hold the creator' ID of this person who sent this quizset

@end
