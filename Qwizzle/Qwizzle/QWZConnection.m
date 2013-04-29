//
//  QWZConnection.m
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZConnection.h"

// This array keep a strong reference to all active QWZConnection
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

// Call this method to initiate a connection
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

// A delegate method for NSURLConnection that get called when the connection finish loading everything
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    id rootObject = nil;
    
    // If there is a "root object"
    if ([self jsonRootObject]) {
        // Create a parser with the incoming data and let the root object parse its contents
        NSString *myString = [[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding];
        //NSLog(@"The raw data was %@", container);
        NSLog(@"The downloaded data was %@", myString);
        
        // Turn JSON data into basic model objects
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:container options:0 error:nil];

        // Have the root object construct itself from basic model objects
        [[self jsonRootObject] setJSON:dict];
        
        rootObject = [self jsonRootObject];
    }
    
    // Then, pass the root object to the completion block
    // This is the block that the controller supplied
    if ([self completionBlock]) {
        
        // Everything went OK, run the supplied codeblock sending the root object (JSON) while the error objcet will be nil 
        [self completionBlock](rootObject, nil);
    }
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

// A delegate method for NSURLConnection that get called when the connection failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection Failed");
    
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock]) {
        
        // Everything went bad, run the supplied codeblock sending error while the root objcet will be nil 
        [self completionBlock](nil, error);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
