//
//  GLHomeController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"

#import "GLHome_AttentionController.h"
#import "GLHome_NewController.h"
#import "GLHome_hotController.h"

@interface GLHomeController ()

@end

@implementation GLHomeController


//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:49])
    {
        self.yFloat = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 3, 49);

    NSArray *titleArray = @[
                            @"关注动态",
                            @"新品推荐",
                            @"热门话题",
                            ];
    
    NSArray *classNames = @[
                            [GLHome_AttentionController class],
                            [GLHome_NewController class],
                            [GLHome_hotController class],
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = YYSRGBColor(233, 76, 137, 1);
    self.selectedIndicatorColor = YYSRGBColor(233, 76, 137, 1);
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
