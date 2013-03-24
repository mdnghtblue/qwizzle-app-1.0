//
//  QWZQuiz.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//BN//hot deals ...

#import "QWZQuiz.h"

@implementation QWZQuiz

// Initialize a property using @synthesize directive, we get a free getter and setter to the property using this method
@synthesize question;
@synthesize answer;
@synthesize dateCreated;

// The designate initializer
- (id)initWithQuestion:(NSString *)q
                answer:(NSString *)a
{
    // Always call the superclass's designated initializer
    self = [super init];
    
    // Is the superclass's designated initializer succeed?
    if (self) {
        [self setQuestion:q]; // Set a question using a setter
        [self setAnswer:a]; // Set an answer using a setter
        dateCreated = [[NSDate alloc] init]; // Initialize the date this quiz
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)initWithQuestion:(NSString *)q
{
    // Call the designated initializer with a default value
    return [self initWithQuestion:q answer:@""];
}

- (id)init
{
    // Call the designated initializer with default values
    return [self initWithQuestion:@"What is your name?" answer:@""];
}

// This message is sent when this quiz was destroyed
- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

// Override the description method (it's like toString() in Java), so that it will print out only what we want on-screen
- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@)", question, dateCreated];
    return descriptionString;
}

@end
