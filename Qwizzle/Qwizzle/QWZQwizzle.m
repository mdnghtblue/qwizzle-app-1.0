//
//  QWZQwizzle.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZQwizzle.h"
#import "QWZAnsweredQuizSet.h"
#import "QWZQuizSet.h"
#import "QWZQuiz.h"

@implementation QWZQwizzle

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize the 2 quizset here
        allQuizSets = [[NSMutableArray alloc] init];
        allAnsweredQuizSets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)generateSampleData
{
    [allQuizSets removeAllObjects];
    [allAnsweredQuizSets removeAllObjects];
    
    // Add hard-coded question set here
    QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
    QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your last name?"];
    
    QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Sample Qwizzle"];
    [qs1 addQuiz:q1];
    [qs1 addQuiz:q2];
    
    QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Sample Qwizzle Pack 2"];
    [qs2 addQuiz:q1];
    
    QWZQuiz *q3 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite color?" answer:@"Green"];
    QWZQuiz *q4 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite food?" answer:@"Fried Rice"];
    QWZQuiz *q5 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite sport?" answer:@"Table Tennis"];
    QWZAnsweredQuizSet *aqs1 = [[QWZAnsweredQuizSet alloc] initWithTitle:@"My favorite things"];
    [aqs1 addQuiz:q3];
    [aqs1 addQuiz:q5];
    [aqs1 addQuiz:q4];
    
    
    [allQuizSets addObject:qs1];
    [allQuizSets addObject:qs2];
    [allAnsweredQuizSets addObject:aqs1];
}

@end