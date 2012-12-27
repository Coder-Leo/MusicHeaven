//
//  AppDelegate.m
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window  = _window,
            rootVC  = _rootVC,
            defaults = _defaults;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];        //使用自定义窗口作为应用窗口
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.rootVC = [[RootViewController alloc]init];
    
    NSUInteger currentPageNumber = [[_defaults objectForKey:@"currentPageNumber"] integerValue];
    NSUInteger indexOfSpecifiedColume = [[_defaults objectForKey:@"indexOfColumn"] integerValue];
    NSUInteger indexOfFileInSpecifiedColumn = [[_defaults objectForKey:@"indexOfFileInSpecifiedColumn"] integerValue];
    
    self.rootVC.currentPageNumber = currentPageNumber;
    self.rootVC.indexOfSpecifiedColume = indexOfSpecifiedColume;
    self.rootVC.indexOfFileInSpecifiedColume = indexOfFileInSpecifiedColumn;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.rootVC];
    
    [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [navController.navigationBar setTintColor:[UIColor colorWithWhite:1.0 alpha:0.0/*colorWithRed:205.0f/255.0f green:192.0f/255.0f blue:176.0f/255.0f alpha:1.0*/]];
    [navController.navigationBar setTranslucent:YES];
    [[navController.navigationBar layer] setMasksToBounds:YES];
    
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"musicheaven" ofType:@"png" inDirectory:@"images/NavigationTitleView"]]];
    [titleView setFrame:CGRectMake(0, 0, 162, 32)];
    
    navController.navigationBar.topItem.titleView = titleView;
    
    
    [_window setRootViewController:navController];
//    DataModal *data = [DataModal defaultModal];
    
//    NSLog(@"-- %@",[data description]);
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"self.rootVC.currentPageNumber = %d",self.rootVC.currentPageNumber);
    [_defaults setObject:[NSNumber numberWithInteger:self.rootVC.currentPageNumber] forKey:@"currentPageNumber"];
    [_defaults setObject:[NSNumber numberWithInteger:[self.rootVC getIndexOfColumn]] forKey:@"indexOfColumn"];
    [_defaults setObject:[NSNumber numberWithInteger:[self.rootVC getIndexOfFileInSpecifiedColumn]] forKey:@"indexOfFileInSpecifiedColumn"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
