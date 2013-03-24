//
//  QWZAppDelegate.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//HOme 

// Test -Stephanie
// Another change
// And yet another change
// Hello everyone!

#import "QWZAppDelegate.h"

// Import our viewcontroller
#import "QWZViewController.h"
#import "Foundation/Foundation.h"

@implementation QWZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    // Krissada: Qwizzle's customization begins here
    
    // Create a QWZViewController
    QWZViewController *qwzViewController = [[QWZViewController alloc] init];
    
    // Create an instance of a UINavigationController
    // its stack contains only qwzViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:qwzViewController];
    
    // Place UINavigationController in the window hierarchy (as the root view)
    [[self window] setRootViewController:navController];
    
    // Krissada: Qwizzle's customization ends here
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end