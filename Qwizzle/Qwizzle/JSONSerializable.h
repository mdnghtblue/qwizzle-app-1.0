//
//  JSONSerializable.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/16/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)dict; // Parse and distribute the json dictionary object according to the structure app's model (for future use)

- (void)setJSON:(NSDictionary *)dict; // Store the json dictionary object 

- (NSDictionary *)JSON; // Access the json dictionary object

@end
