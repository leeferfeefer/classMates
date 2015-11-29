//
//  AppDelegate.m
//  classMates
//
//  Created by Lee Fincher on 9/21/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate



    /*
            Facebook
     */

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    /*
            Facebook
     */
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    
    /*
            Quickblox
     
    */
    
    // Set QuickBlox credentials
    [QBApplication sharedApplication].applicationId = 29742;
    [QBConnection registerServiceKey:@"UbvtQdDGpTRjPy7"];
    [QBConnection registerServiceSecret:@"q2-4n7TYtWHL3pb"];
    [QBSettings setAccountKey:@"Q1o2xYSLQYmszqWRy2Da"];
    
    
    
    self.myMeetings = [NSMutableArray new];
    self.myClasses = [NSMutableArray new];
    

    self.myMeetingIDs = [NSMutableArray new];
    self.idForMeeting = [NSMutableDictionary new];
//    self.myClassIDs = [NSMutableArray new];
    
    self.friendClasses = [NSMutableArray new];
    
    
    //    DISABLE LOG STATEMENTS
    [QBSettings setLogLevel:QBLogLevelNothing];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




#pragma mark - State Preservation

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
