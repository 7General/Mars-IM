//
//  AppDelegate.m
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LongLinkTool.h"
#import "LogHelper.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    
    [[LongLinkTool sharedLongLink] createLongLinkWithAddress:@"10.16.208.39" ports:@[@(8079)] clientVersion:200];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LongLinkTool sharedLongLink] reportOnForegroud:NO];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LongLinkTool sharedLongLink] reportOnForegroud:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[LongLinkTool sharedLongLink] destoryLongLink];
    [LogHelper closeXLog];
    
}


@end
