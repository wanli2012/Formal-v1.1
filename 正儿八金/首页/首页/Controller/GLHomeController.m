//
//  GLHomeController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeController.h"

#import "GLHome_AttentionController.h"
#import "GLHome_hotController.h"
//#import "GLHome_NewController.h"

#import "GLMessageController.h"//消息
#import "GLHome_SearchController.h"//搜索

@interface GLHomeController ()

@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation GLHomeController

//重载init方法
- (instancetype)init{
    
    if (self = [super initWithTagViewHeight:40])
    {
        self.yFloat = 64;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.borderColor = MAIN_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 2, 40);

    NSArray *titleArray = @[@"热门话题",
                            @"关注动态"];
    
    NSArray *classNames = @[[GLHome_hotController class],
                            [GLHome_AttentionController class]
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = MAIN_COLOR;
    self.selectedIndicatorColor = MAIN_COLOR;
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
}

//消息
- (IBAction)message:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMessageController *messageVC = [[GLMessageController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//搜索
- (IBAction)search:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLHome_SearchController *searchVC = [[GLHome_SearchController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

@end
