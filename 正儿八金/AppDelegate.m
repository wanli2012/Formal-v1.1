//
//  AppDelegate.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "DWTabBarController.h"
#import "BaseNavigationViewController.h"

#import "GLHomeController.h"
#import "GLCommunityController.h"
#import "GLFriendController.h"
#import "GLMineController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.window.rootViewController = [[DWTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

//- (CYTabBarController *)setTabbarController{
//    
//    CYTabBarController * tabbarController = [[CYTabBarController alloc]init];
//    
//    /**
//     *  配置外观
//     */
//    [CYTabBarConfig shared].selectedTextColor = [UIColor orangeColor];
//    [CYTabBarConfig shared].textColor = [UIColor grayColor];
//    [CYTabBarConfig shared].backgroundColor = [UIColor whiteColor];
//    [CYTabBarConfig shared].selectIndex = 0;
//    [CYTabBarConfig shared].centerBtnIndex = 2;
//    
//    /**
//     *  style 1 (中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼)
//     */
//    BaseNavigationViewController *homeNav = [[BaseNavigationViewController alloc]initWithRootViewController:[GLHomeController new]];
//    [tabbarController addChildController:homeNav title:@"发现" imageName:@"好友未点中" selectedImageName:@"首页"];
//    
//    BaseNavigationViewController *commNav = [[BaseNavigationViewController alloc]initWithRootViewController:[GLCommunityController new]];
//    [tabbarController addChildController:commNav title:@"我的" imageName:@"好友未点中" selectedImageName:@"首页"];
//    
////    BaseNavigationViewController *midNav = [[BaseNavigationViewController alloc]initWithRootViewController:[GLMineController new]];
//    [tabbarController addCenterController:nil bulge:YES title:@"" imageName:@"post_normal" selectedImageName:@"post_normal"];
//    
//    BaseNavigationViewController *friendNav = [[BaseNavigationViewController alloc]initWithRootViewController:[GLFriendController new]];
//    [tabbarController addChildController:friendNav title:@"好友" imageName:@"好友未点中" selectedImageName:@"首页"];
//    
//    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc]initWithRootViewController:[GLCommunityController new]];
//    [tabbarController addChildController:mineNav title:@"我的" imageName:@"好友未点中" selectedImageName:@"首页"];
//    
//    return tabbarController;
//
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
