//
//  Quiz.h
//  Qwizzle
//
//  Created by Stephanie Day on 3/27/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answers, Question;

@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *answer_r;
@property (nonatomic, retain) NSSet *qustion_r;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)addAnswer_rObject:(Answers *)value;
- (void)removeAnswer_rObject:(Answers *)value;
- (void)addAnswer_r:(NSSet *)values;
- (void)removeAnswer_r:(NSSet *)values;

- (void)addQustion_rObject:(Question *)value;
- (void)removeQustion_rObject:(Question *)value;
- (void)addQustion_r:(NSSet *)values;
- (void)removeQustion_r:(NSSet *)values;

@end
