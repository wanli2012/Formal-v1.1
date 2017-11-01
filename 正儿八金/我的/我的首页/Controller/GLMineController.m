//
//  GLMineViewController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
#import "GLMineCell.h"
#import "GLMine_SetupController.h"//设置
#import "GLMine_PersonInfoController.h"//个人信息
#import "GLMine_EventController.h"//活动
#import "GLMine_MyPostController.h"//我的帖子

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSArray *imageArr;

@property (nonatomic, copy)NSArray *titleArr;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;//等级
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;//经验值

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *myPicImage;//头像
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV;//等级标志

@end

#define kHEIGHT 200

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.myPicImage.layer.cornerRadius = self.myPicImage.height / 2;
    
    self.nameLabel.text = [NSString stringWithFormat:@"用户名:%@",[UserModel defaultUser].user_name];
    self.gradeLabel.text = [NSString stringWithFormat:@"会员等级:%@",[UserModel defaultUser].number_name];
    self.experienceLabel.text = [NSString stringWithFormat:@"经验值:%@",[UserModel defaultUser].experience];
    [self.levelImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].icon ] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    [self.myPicImage sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
//个人信息
- (IBAction)personInfo:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfoController *infoVC = [[GLMine_PersonInfoController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//设置
- (IBAction)setup:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    
    GLMine_SetupController *setupVC = [[GLMine_SetupController alloc] init];
    [self.navigationController pushViewController:setupVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma mark - UIScrollViewDelegate 下拉放大图片
//scrollView的方法视图滑动时 实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;
    // 偏移的y值
    
    if(yOffset < 0){
        
        CGFloat totalOffset = kHEIGHT + ABS(yOffset);
        CGFloat f = totalOffset / kHEIGHT;
        //拉伸后的图片的frame应该是同比例缩放。
        self.bgImageV.frame =  CGRectMake(- (width *f - width) / 2, yOffset, width * f, totalOffset);
        
    }
}

#pragma mark -
#pragma mark  UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMineCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titleLabel.text = self.titleArr[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            GLMine_EventController * eventVC = [[GLMine_EventController alloc] init];
            [self.navigationController pushViewController:eventVC animated:YES];
            
        }
            break;
        case 2:
        {
            GLMine_MyPostController *myPostVC = [[GLMine_MyPostController alloc] init];
            [self.navigationController pushViewController:myPostVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -
#pragma mark lazy

- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"我关注的社区",@"活动",@"商城模块"];
    }
    return _imageArr;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"我关注的社区",@"我参与的活动",@"商城模块"];
    }
    return _titleArr;
}

@end
