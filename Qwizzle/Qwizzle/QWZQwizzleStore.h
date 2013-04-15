//
//  QWZQwizzleStore.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/14/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QWZQwizzleStore : NSObject
{
    
}

+ (QWZQwizzleStore *)sharedStore;

- (void)fetchQwizzleWithCompletion:(void (^)(NSArray *obj, NSError *err))block;

- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(NSArray *obj, NSError *err))block;

@end
