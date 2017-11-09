//
//  GLHome_Search_MainController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_Search_MainController.h"
#import "MSSAutoresizeLabelFlow.h"

#import "GLHome_CommunityController.h"//社区
#import "GLHome_PostController.h"//帖子
#import "GLHome_UserController.h"//用户

@interface GLHome_Search_MainController ()

@property(nonatomic,strong)MSSAutoresizeLabelFlow *secondView;

@property (nonatomic, strong)NSMutableArray *fmdbArr;
@property (nonatomic, strong)NSMutableArray *reCoderArr;
@property (nonatomic,strong)NodataView *nodataV;

@end

@implementation GLHome_Search_MainController

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
    self.navigationItem.title = @"搜索结果";

    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];

}

//-(void)getFmdbDatasoruce{

//    self.fmdbArr = nil;
//    self.reCoderArr = nil;
//    //    _secondView = nil;
//    _secondView = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 70, kSCREEN_WIDTH, kSCREEN_HEIGHT - 70) titles:self.reCoderArr selectedHandler:^(NSUInteger index, NSString *title) {
//        
//        [self.view endEditing:YES];
//        
//    }];
//    //获取本地搜索记录
//    _dataBase = [GLHome_SearchDataBase greateTableOfFMWithTableName:@"GLHome_SearchDataBase"];
//    
//    if ([_dataBase isDataInTheTable]) {
//        self.fmdbArr = [NSMutableArray arrayWithArray:[_dataBase queryAllDataOfFMDB]];
//        for (int i = 0; i < [[_dataBase queryAllDataOfFMDB]count]; i++) {
//            [self.reCoderArr addObject:[_dataBase queryAllDataOfFMDB][i][@"recoder"]];
//        }
//    }else{
//        _secondView.hidden = YES;
//        [self.reCoderArr removeAllObjects];
//        self.fmdbArr = [NSMutableArray array];
//    }
//    
//}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 3, 40);
    
    NSArray *titleArray = @[@"社区",
                            @"帖子",
                            @"用户"];
    
    NSArray *classNames = @[[GLHome_CommunityController class],
                            [GLHome_PostController class],
                            [GLHome_UserController class]
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = MAIN_COLOR;
    self.selectedIndicatorColor = MAIN_COLOR;
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
}

@end
