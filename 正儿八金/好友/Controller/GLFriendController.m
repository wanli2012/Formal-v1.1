//
//  GLFriendController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLFriendController.h"
#import "LBGoodFriendsHeaderView.h"
#import "LBGoodFriendsViewHeaderFooterView.h"

@interface GLFriendController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *navagationView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) LBGoodFriendsHeaderView *goodFriendsHeaderView;

@end

@implementation GLFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableHeaderView = self.goodFriendsHeaderView;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LBMineCenterFlyNoticeTableViewCell" ];
}

#pragma mark --- UITableViewDelegate UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *viewIdentfier = @"LBGoodFriendsViewHeaderFooterView";
    
    LBGoodFriendsViewHeaderFooterView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[LBGoodFriendsViewHeaderFooterView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    sectionHeadView.contentView.backgroundColor = [UIColor redColor];
    return sectionHeadView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

    self.navagationView.layer.shadowColor = YYSRGBColor(207, 207, 207, 1).CGColor;
    self.navagationView.layer.shadowOffset=CGSizeMake(0, 5);
    self.navagationView.layer.shadowOpacity=0.5;

}

-(LBGoodFriendsHeaderView*)goodFriendsHeaderView{

    if (!_goodFriendsHeaderView) {
        _goodFriendsHeaderView = [[NSBundle mainBundle ]loadNibNamed:@"LBGoodFriendsHeaderView" owner:self options:nil].firstObject;
        _goodFriendsHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
         _goodFriendsHeaderView.autoresizingMask = UIViewAutoresizingNone;
    }

    return _goodFriendsHeaderView;

}
@end
