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
#import "JSONContainer.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"
#import "QWZQuiz.h"

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
- (void)fetchQwizzleWithCompletion:(void (^)(JSONContainer *, NSError *))block
{
    NSLog(@"fetchQwizzleWithCompletion with codeblock %@", block);
    
    // Get User's ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    // Construct URL
    NSString *loadQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/qwizzle/%@", userID];
    
    NSURL *url = [NSURL URLWithString:loadQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];

    [req setHTTPMethod:@"GET"];
    
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

// This method fetch all Qwizzle that this user has answered
- (void)fetchAnsweredQwizzleWithCompletion:(void (^)(JSONContainer *, NSError *))block
{
    NSLog(@"fetchAnsweredQwizzleWithCompletion with codeblock: %@", block);
    
    // Get User's ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    NSString *loadAnsweredQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/qwizzle/taken/%@", userID];
    
    NSURL *url = [NSURL URLWithString:loadAnsweredQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    
    [req setHTTPMethod:@"GET"];
    
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

- (void)createAQwizzle:(QWZQuizSet *)quizSet
     WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;
{
    NSLog(@"createAQwizzle %@ with codeblock: %@", quizSet, block);
    
    // Get User's ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    // Construct URL
    NSString *createQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/qwizzle/"];
    
    NSURL *url = [NSURL URLWithString:createQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    
    // Start constructing body message
    [req setHTTPMethod:@"PUT"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"{"];
    
    [postString appendString:[NSString stringWithFormat:@"\"creator\": %@,", userID]];
    [postString appendString:[NSString stringWithFormat:@"\"title\": \"%@\",", [quizSet title]]];
    
    [postString appendString:@"\"questions\": ["];
    NSInteger count = 0;
    for (QWZQuiz *quiz in [quizSet allQuizzes]) {
        if (count > 0) { [postString appendString:@","]; }
        [postString appendString:[NSString stringWithFormat:@"{\"question\": \"%@\"}", [quiz question]]];
        count++;
    }
    [postString appendString:@"]"];
    
    [postString appendString:@"}"];
    
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    // End constructing body message
    
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

- (void)takeAQwizzle:(QWZAnsweredQuizSet *)quizSet WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block
{
    NSLog(@"takeQwizzle %@ with codeblock: %@", quizSet, block);
    
    // Get User's ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    // Construct URL
    NSString *createQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/qwizzle/"];
    
    NSURL *url = [NSURL URLWithString:createQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    
    // Start constructing body message
    [req setHTTPMethod:@"POST"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"{"];
    
    [postString appendString:[NSString stringWithFormat:@"\"user_id\": %@,", userID]];
    [postString appendString:[NSString stringWithFormat:@"\"qwizzle_id\": %@,", userID]];
    
    [postString appendString:@"\"answers\": ["];
    NSInteger count = 0;
    for (QWZQuiz *quiz in [quizSet allQuizzes]) {
        if (count > 0) { [postString appendString:@","]; }
        [postString appendString:[NSString stringWithFormat:@"{\"answer\": \"%@\", \"question_id\": %d}", [quiz answer], [quiz questionID]]];
        count++;
    }
    [postString appendString:@"]"];
    
    [postString appendString:@"}"];
    
    NSLog(@"postString: %@", postString);
    
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    // End constructing body message
    
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

- (void)fetchQuestions:(NSInteger)qwizzleID WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block
{
    NSLog(@"fetchQuestions from QwizzleID %d with codeblock: %@", qwizzleID, block);
    
    // Construct URL
    NSString *createQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/qwizzle/questions/%d", qwizzleID];

    NSURL *url = [NSURL URLWithString:createQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    
    [req setHTTPMethod:@"GET"];
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

- (void)shareAQwizzle:(NSInteger)qwizzleID WithUserID:(NSMutableArray *)user_id AndSenderID:(NSString *)sender_ID WithCompletion:(void (^)(JSONContainer *, NSError *))block
{
    NSLog(@"shareAQwizzle from %@ to %@ with codeblock: %@", sender_ID, user_id, block);
    
    // Get User's ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"user_id"];
    
    // Construct URL
    NSString *createQwizzleURL = [NSString stringWithFormat:@"http://qwizzleapp.com/request/"];
    
    NSURL *url = [NSURL URLWithString:createQwizzleURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    
    // Start constructing body message
    [req setHTTPMethod:@"PUT"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"{"];
    
    [postString appendString:[NSString stringWithFormat:@"\"sender_id\": %@,", userID]];
    [postString appendString:[NSString stringWithFormat:@"\"qwizzle_id\": %d,", qwizzleID]];
    
    [postString appendString:@"\"user_id\": ["];
    for (int i = 0; i < [user_id count]; i++) {
        if (i > 0) {
            [postString appendString:@","];
        }
        [postString appendString:[NSString stringWithFormat:@"{\"id\": %@}", [user_id objectAtIndex:i]]];
    }
    [postString appendString:@"]"];
    
    [postString appendString:@"}"];
    
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    // End constructing body message
    
    NSLog(@"postString: %@", postString);
    
//    // Create an empty JSONContainer
//    JSONContainer *json = [[JSONContainer alloc] init];
//    
//    // Create a connection "actor" object that will transfer data to/from the server
//    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
//    
//    // When the connection completes, this block from the controller will be called
//    [connection setCompletionBlock:block];
//    
//    // Let the empty channel parse the returning data from the web service
//    [connection setJsonRootObject:json];
//    
//    // Fire the connection
//    [connection start];
}

- (void)fetchUserWithUsername:(NSString *)userName andPassword:(NSString *)password WithCompletion:(void (^)(JSONContainer *obj, NSError *err))block;
{
    NSLog(@"fetchUser for User Name %@ with codeblock: %@", userName, block);
    
    //  Construct URL
    NSString *fetchUserURL = [NSString stringWithFormat:@"http://qwizzleapp.com/user"];
    
    NSURL *url = [NSURL URLWithString:fetchUserURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    
    // Prepare the request
    [req setHTTPMethod:@"POST"]; // Or get, push, put
    NSMutableString *parmeters = [[NSMutableString alloc] init];
    [parmeters appendString:@"{\"username\":\"" ];
    [parmeters appendString:userName];
    [parmeters appendString:@"\",\"password\":\"" ] ;
    [parmeters appendString:password];
    [parmeters appendString:@"\"}"];
    
    
    [req setHTTPBody:[parmeters dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Create an empty JSONContainer
    JSONContainer *json = [[JSONContainer alloc] init];
    
    // Create a connection "actor" object that will transfer data to/from the server
    QWZConnection *connection = [[QWZConnection alloc] initWithRequest:req];
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let the empty channel parse the returning data from the web service
    [connection setJsonRootObject:json];
    
    // Fire the connection
    [connection start];
}

@end
