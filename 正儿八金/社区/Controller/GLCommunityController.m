//
//  GLCommunityController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunityController.h"

@interface GLCommunityController ()

@end

@implementation GLCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


@end
