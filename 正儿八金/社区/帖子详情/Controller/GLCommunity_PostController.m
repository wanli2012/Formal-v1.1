//
//  GLCommunity_PostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostController.h"
#import "GLHome_AttentionCell.h"
#import "GLCommunity_PostCommentCell.h"
#import "GLCommunity_PostCommentModel.h"
#import "GLCommentListController.h"

@interface GLCommunity_PostController ()<UITableViewDelegate,UITableViewDataSource,GLCommunity_PostCommentCellDelegate>
{
    GLHome_AttentionModel *_model;
}

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation GLCommunity_PostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.borderColor = MAIN_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentCell"];
    
    _model = [[GLHome_AttentionModel alloc] init];
    _model.sum = @"2";
    _model.content = [NSString stringWithFormat:@"lldsfjj垃圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------"];
    _model.isHiddenAttendBtn = YES;
    _model.isHiddenLandlord = NO;
    _model.isHiddenTitleLabel = YES;
    
    
    for (int j = 0; j < 4; j ++ ) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
            
            GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
            model.son_commentName = @"你大爷";
            model.son_comment = [NSString stringWithFormat:@"dfsfsf代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间拉伸发链接阿拉斯加冯老师sf哈哈回复%zd",i];
            [arr addObject:model];
        }
        
        GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
        model.commentArr = arr;
        model.comment = [NSString stringWithFormat:@"我是主代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师评论:我是主评论:我是主评论:我是主评论:我是主评论:%zd",j];
        [self.dataSource addObject:model];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//返回按钮点击事件
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//举报
- (IBAction)report:(id)sender {
    NSLog(@"我要举报");
}
//发送消息
- (IBAction)sendMessage:(id)sender {
    
    NSLog(@"发送消息");
}


#pragma mark - GLCommunity_PostCommentCellDelegate

- (void)pushController {
    self.hidesBottomBarWhenPushed = YES;
    GLCommentListController *commentListVC = [[GLCommentListController alloc] init];
    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        cell.model = _model;
        return cell;
        
    }else{
        
        GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        cell.model = self.dataSource[indexPath.row - 1];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLCommentListController *commentListVC = [[GLCommentListController alloc] init];
    [self.navigationController pushViewController:commentListVC animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return _model.cellHeight;
        
    }else{
        
        GLCommunity_PostCommentModel *model = self.dataSource[indexPath.row - 1];
        return model.cellHeight;
    }
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
