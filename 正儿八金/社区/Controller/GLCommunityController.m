//
//  GLCommunityController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunityController.h"
#import "GLCommunity_FollowController.h"

@interface GLCommunityController ()

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic, strong)GLCommunity_FollowController *followVC;

@property (nonatomic, strong)GLCommunity_FollowController *followVC2;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *attentedBtn;//关注
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;//推荐


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
        self.followVC2.view.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height);
        [self.bottomView addSubview:self.followVC2.view];
    }
    
}

- (GLCommunity_FollowController *)followVC{
    if (!_followVC) {
        _followVC = [[GLCommunity_FollowController alloc] init];
        
        
    }
    return _followVC;
}

- (GLCommunity_FollowController *)followVC2{
    if (!_followVC2) {
        _followVC2 = [[GLCommunity_FollowController alloc] init];
        
    }
    return _followVC2;
}
@end
