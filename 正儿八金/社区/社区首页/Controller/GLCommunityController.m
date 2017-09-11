//
//  GLCommunityController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunityController.h"
#import "GLCommunity_FollowController.h"
#import "GLCommunity_RecommendController.h"
#import "GLCommunity_DetailController.h"

@interface GLCommunityController ()<GLCommunity_FollowDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic, strong)GLCommunity_FollowController *followVC;

@property (nonatomic, strong)GLCommunity_RecommendController *recommendVC;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *attentedBtn;//关注
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;//推荐

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *dataSource2;

@end

@implementation GLCommunityController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchView.layer.borderColor = MAIN_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    
    [self loadViewIfNeeded];
    
    [self swithType:self.attentedBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (IBAction)swithType:(UIButton *)sender {
    
    [self.attentedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.recommendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    if (sender == self.attentedBtn) {
        self.followVC.view.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height);
        [self.bottomView addSubview:self.followVC.view];
    }else{
        self.recommendVC.view.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height);
        [self.bottomView addSubview:self.recommendVC.view];
    }
    
}

- (void)pushControllerWithIndex:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    GLCommunity_DetailController *detailVC = [[GLCommunity_DetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (GLCommunity_FollowController *)followVC{
    if (!_followVC) {
        _followVC = [[GLCommunity_FollowController alloc] init];
        _followVC.delegate = self;
        for (int i = 0; i < 8; i++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"买菜社区%zd",i]];
        }
         _followVC.dataSource = self.dataSource;
    }
    return _followVC;
}

- (GLCommunity_RecommendController *)recommendVC{
    if (!_recommendVC) {
        _recommendVC = [[GLCommunity_RecommendController alloc] init];
        
        for (int i = 0; i < 8; i++) {
            [self.dataSource2 addObject:[NSString stringWithFormat:@"%zd",i]];
        }
        _recommendVC.dataSource = self.dataSource2;
    }
    return _recommendVC;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)dataSource2{
    if (!_dataSource2) {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}

@end
