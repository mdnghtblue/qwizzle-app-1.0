//
//  QWZQwizzleStore.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/17/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class prepare network request for every object in this app
@interface QWZQwizzleStore : NSObject
{
    
}

// Declare a class method to access this class ensuring that only one of this class could be created ~ the singleton pattern
+ (QWZQwizzleStore *)sharedStore;

// This method fetch all Qwizzle created by this user
- (void)fetchQwizzleWithCompletion:(void (^)(NSArray *obj, NSError *err))block;

// This method fetch all Qwizzle that this user has answered
- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(NSArray *obj, NSError *err))block;

@end
