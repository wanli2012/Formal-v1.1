//
//  GLMine_ApplyRecordController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/12/1.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ApplyRecordController.h"

#import "GLMine_Apply_AuditController.h"//审核中
#import "GLMine_Apply_passedController.h"//已通过
#import "GLMine_Apply_FailedController.h"//未通过

@interface GLMine_ApplyRecordController ()

@end

@implementation GLMine_ApplyRecordController

//重载init方法
- (instancetype)init{
    
    if (self = [super initWithTagViewHeight:40])
    {
        self.yFloat = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"申请记录";
    self.navigationController.navigationBar.hidden = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 3, 40);
    
    NSArray *titleArray = @[@"待审核",
                            @"已通过",
                            @"未通过"];
    
    NSArray *classNames = @[[GLMine_Apply_AuditController class],
                            [GLMine_Apply_passedController class],
                            [GLMine_Apply_FailedController class]
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = MAIN_COLOR;
    self.selectedIndicatorColor = MAIN_COLOR;
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
}

@end
