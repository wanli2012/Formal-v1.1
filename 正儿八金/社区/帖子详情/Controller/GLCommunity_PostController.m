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

@interface GLCommunity_PostController ()<UITableViewDelegate,UITableViewDataSource,GLCommunity_PostCommentCellDelegate>
{
    GLHome_AttentionModel *_postModel;
}

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;//数据源
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

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

    [self.tableView addSubview:self.nodataV];
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
    
    [self.tableView.mj_header beginRefreshing];
    
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
    dic[@"group_id"] = [UserModel defaultUser].groupid;
    dic[@"page"] =@(_page);
    
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

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49 - 49);
    }
    return _nodataV;
    
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
- (IBAction)sendMessage:(id)sender {
    
    NSLog(@"发送消息");
}


#pragma mark - GLCommunity_PostCommentCellDelegate

- (void)pushController:(NSInteger )index {
    
    self.hidesBottomBarWhenPushed = YES;
    
    GLCommentListController *commentListVC = [[GLCommentListController alloc] init];
    
    commentListVC.user_id = self.model.mid;
    commentListVC.group_id = self.model.group_id;
    commentListVC.post_id = self.model.post.post_id;
    commentListVC.comm_id = self.model.main[index-1].comm_id;

    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.mainCommentArr.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.mainCommentArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        cell.postModel = self.model;
        
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
