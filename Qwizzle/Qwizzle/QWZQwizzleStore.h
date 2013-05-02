//
//  QWZQwizzleStore.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/17/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONContainer;
@class QWZQuizSet;
@class QWZAnsweredQuizSet;

// This class prepare network request for every object in this app
@interface QWZQwizzleStore : NSObject

// Declare a class method to access this class ensuring that only one of this class could be created
// ~ This is the singleton pattern
+ (QWZQwizzleStore *)sharedStore;

// This method fetch all Qwizzles created by this user
- (void)fetchQwizzleWithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method fetch all Qwizzles that this user has answered
- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method fetch all Requested Qwizzles for this user
- (void)fetchRequestedQwizzleWithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method send a created Qwizzle to the web service
- (void)createAQwizzle:(QWZQuizSet *)quizSet WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method send a taken Qwizzle to the web service
- (void)takeAQwizzle:(QWZAnsweredQuizSet *)quizSet WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method delete a taken requested Qwizzle to the web service
- (void)deleteARequestedQwizzle:(QWZAnsweredQuizSet *)quizSet WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method send a QwizzleID to get all questions
- (void)fetchQuestions:(NSInteger)qwizzleID WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method send a QwizzleID to get all answers
- (void)fetchAnswers:(NSInteger)qwizzleID WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

// This method fetch account for the user
- (void)fetchUserWithUsername:(NSString *)userName andPassword:(NSString *)password WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

- (void)shareAQwizzle:(NSInteger)qwizzleID WithUserID:(NSMutableArray *)user_id AndSenderID:(NSString *)sender_ID WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;

@end
