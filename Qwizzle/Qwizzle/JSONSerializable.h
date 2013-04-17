//
//  JSONSerializable.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)dict;

@end
