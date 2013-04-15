//
//  QWZConnection.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 4/14/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface QWZConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    // Connection needs instance variables and properties to hold the connection, request, and callback
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

@property (nonatomic, strong) id <JSONSerializable> jsonRootObject; 

- (void)start;

@end
