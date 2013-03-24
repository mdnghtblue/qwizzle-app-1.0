//
//  QWZQuizSet.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

// Using @class directive allow us to use QWZQuiz as a declaration name w/o importing a whole header file
// The compiler does not need to know the detail implementation of the class, save compilation time
@class QWZQuiz;

@interface QWZQuizSet : NSObject
{
    // This array stores all created quizzes
    NSMutableArray *allQuizzes;
}

@property (nonatomic, copy) NSString *title;   // Hold the title of this set of quiz

// The designated initializer
- (id)initWithTitle:(NSString *)title;

// Get all quizzes
- (NSArray *)allQuizzes;

// Add a new quiz
- (void)addQuiz:(QWZQuiz *)q;

// Remove a quiz
- (void)removeQuiz:(QWZQuiz *)q;

// Move a quiz from an index to another index
- (void)moveQuizAtIndex:(int)from toIndex:(int)to;

@end
