//
//  DWTabBarController.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBarController.h"
#import "BaseNavigationViewController.h"
#import "GLHomeController.h"
#import "GLCommunityController.h"
#import "GLFriendController.h"
#import "GLMineController.h"

#import "DWTabBar.h"
#import "GLFriendController.h"
#import "GLLoginController.h"
#import "AppDelegate.h"
#import "NTESCustomNotificationDB.h"

#define DWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0] //用10进制表示颜色，例如（255,255,255）黑色
#define DWRandomColor DWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
@interface DWTabBarController ()<UITabBarControllerDelegate,NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>
@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,assign) NSInteger systemUnreadCount;

@property (nonatomic,assign) NSInteger customSystemUnreadCount;
@end


@implementation DWTabBarController

#pragma mark -
#pragma mark - Life Cycle
+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[DWTabBarController class]]) {
        return (DWTabBarController *)vc;
    }else{
        return nil;
    }
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //设置导航控制器颜色为黄色
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(exitLogin) name:@"exitLogin" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(selectChatVc) name:@"selectChatVc" object:nil];//聊天未读数
   [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(jumploginInterface) name:@"jumploginInterface" object:nil];//跳转登录界面
}

//完善资料退出跳转登录
-(void)exitLogin{
    
    self.selectedIndex = 0;
}

//刷新界面
-(void)refreshInterface{
    
    [self.viewControllers reverseObjectEnumerator];
    [self setUpChildViewController];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:3] ) {
    
        if ([UserModel defaultUser].loginstatus == YES) {
            
            return YES;
        }
        
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
        
    }

    return YES;
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把 系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar{
    
    [self setValue:[[DWTabBar alloc] init] forKey:@"tabBar"];
}


/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes{
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
    
}


/**
 *  添加子控制器，我这里值添加了4个，没有占位自控制器
 */
- (void)setUpChildViewController{
    
    [self addOneChildViewController:[[BaseNavigationViewController alloc]initWithRootViewController:[[GLHomeController alloc]init]]
                          WithTitle:@"首页"
                          imageName:@"首页未点中"
                  selectedImageName:@"首页"];
    
    [self addOneChildViewController:[[BaseNavigationViewController alloc]initWithRootViewController:[[GLCommunityController alloc] init]]
                          WithTitle:@"社区"
                          imageName:@"社区未点中"
                  selectedImageName:@"社区"];
    
    
    [self addOneChildViewController:[[BaseNavigationViewController alloc]initWithRootViewController:[[GLFriendController alloc]init]]
                          WithTitle:@"好友"
                          imageName:@"好友未点中"
                  selectedImageName:@"好友"];
    
    
    [self addOneChildViewController:[[BaseNavigationViewController alloc]initWithRootViewController:[[GLMineController alloc]init]]
                          WithTitle:@"我的"
                          imageName:@"我的未点中"
                  selectedImageName:@"我的"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    
    viewController.view.backgroundColor     = [UIColor whiteColor];
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [UIImage imageNamed:imageName];
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
    
}
-(void)selectChatVc{
    
    self.selectedIndex = 2;//选中聊天界面
    
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.systemUnreadCount = unreadCount;
    [self refreshContactBadge];
}

#pragma mark - Notification

- (void)refreshSessionBadge{
    UINavigationController *nav = self.viewControllers[2];
    nav.tabBarItem.badgeValue = self.self.systemUnreadCount + self.sessionUnreadCount ? @(self.self.systemUnreadCount + self.sessionUnreadCount).stringValue : nil;
    
}

- (void)refreshContactBadge{
    UINavigationController *nav = self.viewControllers[2];
    NSInteger badge = self.systemUnreadCount + self.sessionUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
    
}
//跳转到登录界面
-(void)jumploginInterface{
   
    
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//这个方法可以抽取到 UIImage 的分类中
- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
