//
//  QWZQwizzleStore.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/17/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZQwizzleStore.h"
#import "QWZConnection.h"

// The store need to know the data structure
#import "QWZQwizzle.h"

@implementation QWZQwizzleStore

// Declaring this store as a singleton object
+ (QWZQwizzleStore *)sharedStore
{
    static QWZQwizzleStore *qwizzleStore = nil;
    
    // If this class has not been created, create a new one otherwise do nothing
    if (!qwizzleStore) {
        qwizzleStore = [[QWZQwizzleStore alloc] init];
    }
    return qwizzleStore;
}

// This method fetch all Qwizzle created by this user
- (void)fetchQwizzleWithCompletion:(void (^)(NSArray *, NSError *))block
{
    NSLog(@"fetchQwizzleWithCompletion");
    
    NSURL *url = [NSURL URLWithString:@"http://qwizzleapp.com/users.php"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create an empty Qwizzle
    QWZQwizzle *qwizzle = [[QWZQwizzle alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:qwizzle];
    
    // Fire the connection
    [connection start];
}

// This method fetch all Qwizzle that this user has answered
- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(NSArray *, NSError *))block
{
    NSLog(@"fetchAnsweredQwizzleWithCompletion");
    
    NSURL *url = [NSURL URLWithString:@"http://boatboat001.com/index.php/feed/popular.json"];
}

@end
