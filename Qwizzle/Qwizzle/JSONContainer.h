//
//  QWZJSONContainer.h
//  Qwizzle
//
//  Created by Team Qwizzle on 4/24/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface JSONContainer : NSObject <JSONSerializable>

@property (nonatomic, copy) NSMutableDictionary *JSONData;

// Implement the JSONSerializable protocol
- (void)setJSON:(NSMutableDictionary *)JSON;
- (NSMutableDictionary *)JSON;

@end
