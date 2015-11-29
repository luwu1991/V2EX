//
//  AppDelegate.m
//  V2EX
//
//  Created by 吴露 on 15/9/5.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "ClasslfyViewController.h"
#import "NewestViewController.h"
#import "MeViewController.h"
#import "CollectViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor clearColor];
    
    
    UITabBarController *tabbar = [[UITabBarController alloc]init];
    
//    LoginViewController *logVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    logVC.tabBarItem.title = @"登录";
////    logVC.tabBarItem.image = [UIImage imageNamed:@"iconfont-yonghuming.png"];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logVC];
//    [tabbar addChildViewController:nav];
//    [tabbar addChildViewController:nav];
    
    NewestViewController *newestVC = [[NewestViewController alloc]init];
    newestVC.tabBarItem.title = @"最热";
    [newestVC.tabBarItem setImage:[UIImage imageNamed:@"section_latest"]];
    UINavigationController *newextNV = [[UINavigationController alloc]initWithRootViewController:newestVC];
    
    ClasslfyViewController *classlfyVC = [[ClasslfyViewController alloc]init];
    classlfyVC.tabBarItem.title = @"类别";
    [classlfyVC.tabBarItem setImage:[UIImage imageNamed:@"section_categories"]];
    UINavigationController *classlfyNV = [[UINavigationController alloc]initWithRootViewController:classlfyVC];
    
    CollectViewController *collectVC = [[CollectViewController alloc]init];
    collectVC.tabBarItem.title = @"收藏";
    [collectVC.tabBarItem setImage:[UIImage imageNamed:@"section_fav"]];
    UINavigationController *collectNV = [[UINavigationController alloc]initWithRootViewController:collectVC];
    
    MeViewController *meVC = [[MeViewController alloc]init];
    meVC.tabBarItem.title = @"我";
    [meVC.tabBarItem setImage:[UIImage imageNamed:@"section_profile"]];
    UINavigationController *meNV = [[UINavigationController alloc]initWithRootViewController:meVC];
    
    tabbar.viewControllers = @[newextNV,classlfyNV,collectNV,meNV];
    self.window = window;
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
