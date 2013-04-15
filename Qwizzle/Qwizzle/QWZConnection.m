//
//  QWZConnection.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/14/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZConnection.h"

//This array keep a strong reference to all active QWZConnection
static NSMutableArray *sharedConnectionList = nil;

@implementation QWZConnection

@synthesize request, completionBlock, jsonRootObject;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initiate container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
    }
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

// A delegate method for NSURLConnection that retrieve the data and report success or failure
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    
    // If there is a "root object"
    if ([self jsonRootObject]) {
        // Create a parser with the incoming data and let the root object parse its contents
        
        // Turn JSON data into basic model objects
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:container options:0 error:nil];
        
        // Have the root object construct itself from basic model objects
        [[self jsonRootObject] readFromJSONDictionary:dict];
        
        rootObject = [self jsonRootObject];
    }
    
    // Then, pass the root object to the completion block
    // This is the block that the controller supplied
    if ([self completionBlock]) {
        [self completionBlock](rootObject, nil);
    }
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
