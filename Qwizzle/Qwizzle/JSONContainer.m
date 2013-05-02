//
//  QWZJSONContainer.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/24/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "JSONContainer.h"

@implementation JSONContainer

@synthesize JSONData;

// Implement the JSONSerializable protocol
// Parse and distribute the json dictionary object according to the structure app's model (for future use)
- (void)readFromJSONDictionary:(NSDictionary *)dict
{
    NSLog(@"reading data from Qwizzle root object: %@", dict);
    NSMutableArray *q = [dict objectForKey:@"data"];
    NSLog(@"all the question is here: %@", q);
    NSLog(@"There are %d quizsets here", [q count]);
    
    // Lop through all quizzes
    for (int i = 0; i < [q count]; i++) {
        NSLog(@"%d) %@", i, [[q objectAtIndex:i] objectForKey:@"title"]);
    }
}

// Store the json dictionary object 
- (void)setJSON:(NSMutableDictionary *)JSON
{
    [self setJSONData:[JSON copy]];
}

// Access the json dictionary object
- (NSMutableDictionary *)JSON
{
    return [self JSONData];
}

@end
