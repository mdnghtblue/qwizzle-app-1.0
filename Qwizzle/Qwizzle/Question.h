//
//  Question.h
//  Qwizzle
//
//  Created by Stephanie Day on 3/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answers, Quiz;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) Answers *answer_r;
@property (nonatomic, retain) Quiz *quiz_r;

@end
