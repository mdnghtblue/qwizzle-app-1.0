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

// Reading and handle JSON's dictionary data
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

- (void)setJSON:(NSMutableDictionary *)JSON
{
    [self setJSONData:[JSON copy]];
}

- (NSDictionary *)JSON
{
    return [self JSONData];
}

@end
