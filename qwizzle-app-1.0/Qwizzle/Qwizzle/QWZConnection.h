//
//  QWZConnection.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

// This class handle a routine network connection with an external web service
@interface QWZConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    // Connection needs instance variables and properties to hold the connection, request, and callback
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

// Initializer that the store would call to set everything up
- (id)initWithRequest:(NSURLRequest *)req;

// Call this method to initiate a connection
- (void)start;

// The request received from the store object
@property (nonatomic, copy) NSURLRequest *request;

// The block of code to be executed after the connection is complete
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

// The object that will receive the downloaded data and do the JSON parsing
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

@end
