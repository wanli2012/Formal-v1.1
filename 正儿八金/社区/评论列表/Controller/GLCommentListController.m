//
//  GLCommentListController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommentListController.h"
#import "GLCommentCell.h"
#import "GLCommentListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"
#import "GLMine_MyPostController.h"

@interface GLCommentListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,GLCommentCellDelegate>
{
    NSInteger _commentIndex;//评论哪一行
    
    NSString *_signStr;
}
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//主评论内容
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//主评论头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//主评论名字
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//主评论日期
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//评论按钮



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论View
@property (weak, nonatomic) IBOutlet UITextField *commentTF;

@property (nonatomic, strong)GLCommentListModel *model;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
//@property (nonatomic,strong)NodataView *nodataV;


@end

@implementation GLCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommentCell"];
    
    
//    [self.tableView addSubview:self.nodataV];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getData:YES];
        
    }];
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [weakSelf getData:NO];
//        
//    }];
//    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
//    self.tableView.mj_footer = footer;
    
//    [self.tableView.mj_header beginRefreshing];
    [self getData:YES];
    
}
//为头视图赋值
- (void)setHeader{

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if (self.model.user_name.length == 0) {
        self.nameLabel.text = self.model.phone;
    }else{
        self.nameLabel.text = self.model.user_name;
    }
    self.dateLabel.text = [formattime formateTimeOfDate:self.model.commenttiem];
    self.commentLabel.text = self.model.content;
    [self.priseBtn setTitle:self.model.reply_laud forState:UIControlStateNormal];
    [self.commentBtn setTitle:self.model.reply_publish forState:UIControlStateNormal];
    
    if ([self.model.fabulous integerValue] == 1) {//已点赞
        [self.priseBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
    }else{
        [self.priseBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    CGSize titleSize = [self.model.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    self.headerView.height = 80 + titleSize.height;
    
    self.commentView.alpha = 0;
    
}

//获取数据
- (void)getData:(BOOL)status {
    
//    if (status){
//        _page = 1;
        [self.dataSource removeAllObjects];
//    }else{
//        _page ++;
//    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_id"] = self.user_id;
    dic[@"post_id"] = self.post_id;
    dic[@"comm_id"] = self.comm_id;
    dic[@"group_id"] = self.group_id;
//    dic[@"page"] =@(_page);
    
    if ([UserModel defaultUser].loginstatus == YES) {
        
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].userId;
        dic[@"group"] = [UserModel defaultUser].groupid;

    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGET_SECOND_COMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            
            self.model = [GLCommentListModel mj_objectWithKeyValues:responseObject[@"data"]];

            [self setHeader];//为头视图赋值
            
            for (commentModel *model in self.model.post) {
                
                [self.dataSource addObject:model];
            }
            
        }else if([responseObject[@"code"] integerValue] == NO_MORE_CODE){
            if(_page != 1){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [self endRefresh];
        [_loadV removeloadview];
        [self.tableView reloadData];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)readThePost:(id)sender {
    NSLog(@"查看原帖子");
}

- (IBAction)commentPraise:(id)sender {
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"commid"] = self.model.mid;
    dic[@"data"] = @"1";
    dic[@"postid"] = self.post_id;
    dic[@"port"] = @"1";//1:ios 2:安卓 3:web 默认1
    
    if([self.model.fabulous isEqualToString:@"1"]){//返回值fabulous:1已关注 2:未关注
        dic[@"type"] = @"2";//参数status:1 点赞   2:取消点赞
    }else{
        dic[@"type"] = @"1";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCOMMENT_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            NSInteger praise = [self.model.reply_laud integerValue];
            //cell刷新
            if([self.model.fabulous isEqualToString:@"1"]){//fabulous:1已关注 2:未关注
                self.model.fabulous = @"2";
                self.model.reply_laud = [NSString stringWithFormat:@"%zd",praise - 1];
                [MBProgressHUD showSuccess:@"取消点赞"];
            }else{
                self.model.fabulous = @"1";
                self.model.reply_laud = [NSString stringWithFormat:@"%zd",praise + 1];
                [MBProgressHUD showSuccess:@"点赞+1"];
            }
            
            [self setHeader];//为头视图赋值
            
            self.block(self.model.reply_laud,self.model.fabulous);
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        [self.tableView reloadData];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

- (IBAction)personInfo:(id)sender {
    NSLog(@"个人信息");
}

#pragma mark - 直接评论 一级评论
- (IBAction)comment:(id)sender {

    if([self.model.mid isEqualToString:[UserModel defaultUser].userId]){
        [MBProgressHUD showError:@"不能回复自己!"];
        return;
    }
    
    self.commentView.alpha = 1;
    [self.commentTF becomeFirstResponder];
    self.commentTF.placeholder = [NSString stringWithFormat:@"回复%@",self.model.user_name];
    _commentIndex = -1;
}

- (IBAction)send:(NSInteger )index{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"data"] = @"2";//评论标识. 1一级评论 2 二级评论
    dic[@"post_id"] = self.post_id;
    dic[@"content"] = self.commentTF.text;
    dic[@"port"] = @"1";
    dic[@"mid"] = self.model.mid;//一级评论人id

    dic[@"comm_id"] = self.model.comm_id;
    
    if (_commentIndex != -1) {//回复二级评论
    
        dic[@"mcid"] =self.model.post[index].mid;

    }
    
    _loadV=[LoadWaitView addloadview:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCOMMENT_POST_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            
            self.commentTF.text = nil;
            [self.commentTF resignFirstResponder];
            self.commentView.alpha = 0;
            
            [self getData:YES];
            
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.dataSource.count - 1];
//            
//            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//            
//            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//             
//                                        animated:YES
//             
//                                  scrollPosition:UITableViewScrollPositionTop];

            
        }else if([responseObject[@"code"] integerValue] == 108){
            if(_page != 1){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [self endRefresh];
        [_loadV removeloadview];
        [self.tableView reloadData];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self send:_commentIndex];
    
    return YES;
}

#pragma mark - GLCommentCellModelDelegate
//查看评论人
- (void)commentPersonInfo:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    
    commentModel *model = self.dataSource[index];
    
    GLMine_MyPostController *personVC = [[GLMine_MyPostController alloc] init];
    personVC.targetUID = model.mid;
    personVC.targetGroupID = model.group_id;
    
     [self.commentTF resignFirstResponder];
    [self.navigationController pushViewController:personVC animated:YES];
    
}

//查看被回复人
- (void)otherPersonInfo:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    
    commentModel *model = self.dataSource[index];
    
    GLMine_MyPostController *personVC = [[GLMine_MyPostController alloc] init];
    personVC.targetUID = model.mcid;
    personVC.targetGroupID = model.identity;
    
    [self.commentTF resignFirstResponder];
    [self.navigationController pushViewController:personVC animated:NO];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommentCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.model = self.model.post[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;

    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    commentModel *model = self.dataSource[indexPath.row];
   
    if([model.mid isEqualToString:[UserModel defaultUser].userId]){
        [MBProgressHUD showError:@"不能回复自己!"];
        return;
    }
    
    self.commentView.alpha = 1;
    [self.commentTF becomeFirstResponder];
    
    self.commentTF.placeholder = [NSString stringWithFormat:@"回复%@",model.user_name];
    _commentIndex = indexPath.row;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
