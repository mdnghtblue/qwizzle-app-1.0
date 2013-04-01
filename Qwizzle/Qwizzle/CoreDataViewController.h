//
//  CoreDataViewController.h
//  Qwizzle
//
//  Created by Stephanie Day on 3/30/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreDataViewController : UIViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
