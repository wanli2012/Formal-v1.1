//
//  GLMineViewController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"

@interface GLMineController ()

@end

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

@end
