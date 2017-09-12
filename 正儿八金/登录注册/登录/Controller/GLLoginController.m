//
//  GLLoginController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"
#import "UIViewController+WXSTransition.h"

@interface GLLoginController ()

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)login:(id)sender {
    NSLog(@"登录");
}


- (IBAction)registe:(id)sender {

    [self wxs_presentViewController:[[GLRegisterController alloc] init] animationType:WXSTransitionAnimationTypePageTransition + 11  completion:nil];
    
}
//忘记密码
- (IBAction)forget:(id)sender {
    NSLog(@"忘记密码");
}


@end
