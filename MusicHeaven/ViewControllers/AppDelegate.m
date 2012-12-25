//
//  AppDelegate.m
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window,
            rootVC = _rootVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];        //使用自定义窗口作为应用窗口
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.rootVC = [[RootViewController alloc]init];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.rootVC];
    
    [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [navController.navigationBar setTintColor:[UIColor colorWithRed:205.0f/255.0f green:192.0f/255.0f blue:176.0f/255.0f alpha:1.0]];
    [navController.navigationBar setTranslucent:YES];
    navController.navigationBar.topItem.title = @"音乐天堂";
    
    
    [_window setRootViewController:navController];
//    DataModal *data = [DataModal defaultModal];
    
//    NSLog(@"-- %@",[data description]);
    
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
