//
//  AppDelegate.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [IQKeyboardManager sharedManager ].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[MainViewController class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[LoginViewController class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ForgotViewController class]];


    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}


@end
