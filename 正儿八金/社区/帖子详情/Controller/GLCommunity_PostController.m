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
#import "GLCommentListController.h"
//#import "GLCommunity_PostCommentModel.h"
//#import "GLCommunity_PostMainCommentModel.h"

@interface GLCommunity_PostController ()<UITableViewDelegate,UITableViewDataSource,GLCommunity_PostCommentCellDelegate,GLHome_AttentionCellDelegate,UITextFieldDelegate>
{
    GLHome_AttentionModel *_postModel;
}

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;//数据源
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UITextField *commentTF;//

@property (nonatomic, strong)GLCommunity_PostCommentModel * model;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;//社区名
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;//话题

@property (nonatomic, strong)NSMutableArray *mainCommentArr;//主评论数组
@property (nonatomic, strong)NSMutableArray *sonCommentArr;//子评论数组


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

    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getData:YES];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getData:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self getData:YES];
    
}

- (void)getData:(BOOL)status {
    
    if (status){
        _page = 1;
        [self.mainCommentArr removeAllObjects];
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"mid"] = self.mid;
    dic[@"post_id"] = self.post_id;
    dic[@"group_id"] = self.group_id;
    dic[@"page"] =@(_page);
    
    if ([UserModel defaultUser].loginstatus == YES) {
        
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].userId;
        dic[@"group"] = [UserModel defaultUser].groupid;
        
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            
            self.model = [GLCommunity_PostCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.model.isHiddenAttendBtn = YES;
            self.model.isHiddenLandlord = NO;
            self.model.isHiddenTitleLabel = NO;
            
            self.communityNameLabel.text = self.model.post.paste_name;
//            self.topicLabel.text = self.model.post;
            
            for (mainModel *model in self.model.main) {

                [self.mainCommentArr addObject:model];
            }

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

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
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
- (IBAction)sendMessage {
//    NSLog(@"发送消息kCOMMENT_POST_URL");
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"uid"] = [UserModel defaultUser].userId;
//    dic[@"group"] = [UserModel defaultUser].groupid;
//    dic[@"data"] = @"1";
//    dic[@"post_id"] = self.post_id;
////    dic[@"content"] = self.;
//    dic[@"comm_id"] = [UserModel defaultUser].userId);
//    dic[@"mcid"] = nil;
//    dic[@"port"] = @"1";
//    
//    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:kPOST_DETAIL_URL paramDic:dic finish:^(id responseObject) {
//        
//        [self endRefresh];
//        [_loadV removeloadview];
//        
//        if ([responseObject[@"code"] integerValue] == 104) {
//            
//            if ([responseObject[@"data"] count] == 0) {
//                
//                [self.tableView reloadData];
//                
//                return;
//            }
//            
//            self.model = [GLCommunity_PostCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
//            self.model.isHiddenAttendBtn = YES;
//            self.model.isHiddenLandlord = NO;
//            self.model.isHiddenTitleLabel = NO;
//            
//            self.communityNameLabel.text = self.model.post.paste_name;
//            //            self.topicLabel.text = self.model.post;
//            
//            for (mainModel *model in self.model.main) {
//                
//                [self.mainCommentArr addObject:model];
//            }
//            
//        }else if([responseObject[@"code"] integerValue] == 108){
//            if(_page != 1){
//                [MBProgressHUD showError:responseObject[@"message"]];
//            }
//            
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//        [self.tableView reloadData];
//        
//    } enError:^(NSError *error) {
//        
//        [self endRefresh];
//        [_loadV removeloadview];
//        [self.tableView reloadData];
//        [MBProgressHUD showError:error.localizedDescription];
//        
//    }];
//
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendMessage];
    
    return YES;
}

#pragma mark - GLCommunity_PostCommentCellDelegate

- (void)pushController:(NSInteger )index {
    
    self.hidesBottomBarWhenPushed = YES;
    mainModel *model = self.mainCommentArr[index - 1];
    
    GLCommentListController *commentListVC = [[GLCommentListController alloc] init];
    
    commentListVC.user_id = self.model.mid;
    commentListVC.group_id = self.model.group_id;
    commentListVC.post_id = self.model.post.post_id;
    commentListVC.comm_id = model.comm_id;
    
    typeof(self)weakSelf = self;
    commentListVC.block = ^(NSString *praise,NSString *fablous){
        
        model.ctfabulous = fablous;
        model.reply_laud = praise;
        
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index inSection:0]; //刷新第0段第2行
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];

    };

    [self.navigationController pushViewController:commentListVC animated:YES];
}
- (void)prise:(NSInteger)index{
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    mainModel *model = self.mainCommentArr[index - 1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"commid"] = model.comm_id;
    dic[@"data"] = @"1";
    dic[@"postid"] = self.model.post.post_id;
    dic[@"port"] = @"1";//1:ios 2:安卓 3:web 默认1
    
    if([model.ctfabulous isEqualToString:@"1"]){//返回值fabulous:1已关注 2:未关注
        dic[@"type"] = @"2";//参数status:1 点赞   2:取消点赞
    }else{
        dic[@"type"] = @"1";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCOMMENT_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            NSInteger praise = [model.reply_laud integerValue];
            //cell刷新
            if([model.ctfabulous isEqualToString:@"1"]){//fabulous:1已关注 2:未关注
                model.ctfabulous = @"2";
                model.reply_laud  = [NSString stringWithFormat:@"%zd",praise - 1];
                [MBProgressHUD showSuccess:@"取消点赞"];
            }else{
                model.ctfabulous = @"1";
                model.reply_laud  = [NSString stringWithFormat:@"%zd",praise + 1];
                [MBProgressHUD showSuccess:@"点赞+1"];
            }
            
            
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index - 1 inSection:0]; //刷新第0段第2行
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            
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
//评价
- (void)comment:(NSInteger)index{
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    NSLog(@"评价%zd",index);
}

#pragma mark - GLHome_AttentionCellDelegate
//点赞
- (void)postPraise:(NSInteger)index{
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"postid"] = self.model.post.post_id;
    dic[@"port"] = @"1";//1:ios 2:安卓 3:web 默认1
    
    if([self.model.post.fabulous isEqualToString:@"1"]){//返回值fabulous:1已关注 2:未关注
        dic[@"type"] = @"2";//参数status:1 点赞   2:取消点赞
    }else{
        dic[@"type"] = @"1";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            NSInteger praise = [self.model.post.praise integerValue];
            //cell刷新
            if([self.model.post.fabulous isEqualToString:@"1"]){//fabulous:1已关注 2:未关注
                self.model.post.fabulous = @"2";
                self.model.post.praise  = [NSString stringWithFormat:@"%zd",praise - 1];
                [MBProgressHUD showSuccess:@"取消点赞"];
            }else{
                self.model.post.fabulous = @"1";
                self.model.post.praise  = [NSString stringWithFormat:@"%zd",praise + 1];
                [MBProgressHUD showSuccess:@"点赞+1"];
                
            }
            
             self.block(self.model.post.praise,self.model.post.fabulous);
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index inSection:0]; //刷新第0段第2行
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            
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


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.mainCommentArr.count <= 0 ) {
//        self.nodataV.hidden = NO;
//    }else{
//        self.nodataV.hidden = YES;
//    }
    
    return self.mainCommentArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        cell.postModel = self.model;
        cell.delegate = self;
        
        return cell;
        
    }else{
        
        GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.model = self.mainCommentArr[indexPath.row - 1];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return;
    }
    
    [self pushController:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return self.model.cellHeight;
        
    }else{
        if (self.mainCommentArr.count == 0) {
            return 0;
        }
        mainModel *model = self.mainCommentArr[indexPath.row - 1];
        return model.cellHeight;

    }
}

- (NSMutableArray *)mainCommentArr{
    if (!_mainCommentArr) {
        _mainCommentArr = [NSMutableArray array];
    }
    return _mainCommentArr;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

@end
