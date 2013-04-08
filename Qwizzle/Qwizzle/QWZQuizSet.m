//
//  QWZQuizSet.m
//  Qwizzle
//
//  Created by Team Qwizzle on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZQuizSet.h"

@implementation QWZQuizSet

@synthesize title;
@synthesize creator;
@synthesize dateCreated;

// The designated initializer
- (id)initWithTitle:(NSString *)t
{
    // Always call the superclass's designated initializer
    self = [super init];
    
    // Is the superclass's designated initializer succeed?
    if (self) {
        allQuizzes = [[NSMutableArray alloc] init];
        title = [t copy];
        dateCreated = [[NSDate alloc] init]; // Initialize the date this quiz
        creator = [[NSString alloc] initWithFormat:@"Lucy"]; // We will get it from the device UniqueID
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init
{
    // Call the designated initializer with a default value
    return [self initWithTitle:@"Default Title"];
}

// Get all quizzes
- (NSArray *)allQuizzes
{
    return allQuizzes;
}

// Add a new quiz
- (void)addQuiz:(QWZQuiz *)q
{
    [allQuizzes addObject:q];
}

// Remove a quiz
- (void)removeQuiz:(QWZQuiz *)q
{
    [allQuizzes removeObjectIdenticalTo:q];
}

// Move a quiz from an index to another index
- (void)moveQuizAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    
    // Get pointer to object being moved so we can re-insert it
    QWZQuiz *quiz = [allQuizzes objectAtIndex:from];
    
    // Remove quiz from array
    [allQuizzes removeObjectAtIndex:from];
    
    // Insert quiz in array at the new location
    [allQuizzes insertObject:quiz atIndex:to];
}

@end
