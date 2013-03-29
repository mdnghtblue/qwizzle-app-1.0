//
//  Answers.h
//  Qwizzle
//
//  Created by Stephanie Day on 3/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, Quiz;

@interface Answers : NSManagedObject

@property (nonatomic, retain) NSNumber * a_id;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * postor;
@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) Quiz *quiz_r;
@property (nonatomic, retain) Question *qustion_r;

@end
