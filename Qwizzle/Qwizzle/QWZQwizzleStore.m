//
//  QWZQwizzleStore.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/17/13.
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
- (void)fetchQwizzleWithCompletion:(void (^)(QWZQwizzle *, NSError *))block
{
    NSLog(@"fetchQwizzleWithCompletion with codeblock %@", block);
    
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
- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(QWZQwizzle *, NSError *))block
{
    NSLog(@"fetchAnsweredQwizzleWithCompletion with codeblock: %@", block);
    
    NSURL *url = [NSURL URLWithString:@"http://boatboat001.com/index.php/feed/latest.json"];
}

// Test sending information to the server
- (void)sendInformationToServerWithCompletion:(void (^)(QWZQwizzle *, NSError *))block
{
    NSLog(@"sendInformationToServerWithCompletion with codeblock: %@", block);
    
    NSURL *url = [NSURL URLWithString:@"http://boatboat001.com/index.php/feed/submit_info.json"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [req setHTTPMethod:@"POST"];
    NSString *postString = @"company=nanosoft&quality=AWESOME!";
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
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

@end
