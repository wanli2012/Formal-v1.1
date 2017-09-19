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
//#import "GLCommunity_PostCommentModel.h"
#import "GLCommentListController.h"
#import "GLCommunity_PostMainCommentModel.h"

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

//@property (nonatomic, strong)GLCommunity_PostCommentModel * commentModel;


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
    

    
    
//    for (int j = 0; j < 4; j ++ ) {
//        
//        NSMutableArray *arr = [NSMutableArray array];
//        for (int i = 0; i < 3; i ++) {
//            
//            GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
//            model.son_commentName = @"你大爷";
//            model.son_comment = [NSString stringWithFormat:@"dfsfsf代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间拉伸发链接阿拉斯加冯老师sf哈哈回复%zd",i];
//            [arr addObject:model];
//        }
//        GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
//        model.commentArr = arr;
//        model.comment = [NSString stringWithFormat:@"我是主代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师评论:我是主评论:我是主评论:我是主评论:我是主评论:%zd",j];
//        [self.dataSourceArr addObject:model];
//    }
    
    
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
            
            _postModel = [[GLHome_AttentionModel alloc] init];
            _postModel.sum = @"2";
            _postModel.content = [NSString stringWithFormat:@"lldsfjj垃圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------"];
            _postModel.isHiddenAttendBtn = YES;
            _postModel.isHiddenLandlord = NO;
            _postModel.isHiddenTitleLabel = YES;
            _postModel.portrait = responseObject[@"data"][@"portrait"];
            _postModel.user_name = responseObject[@"data"][@"user_name"];
            _postModel.post.time = responseObject[@"data"][@"post"][@"time"];
            _postModel.post.praise = responseObject[@"data"][@"post"][@"praise"];
            _postModel.post.quantity = responseObject[@"data"][@"post"][@"pv"];
            _postModel.post.title = responseObject[@"data"][@"post"][@"title"];
            _postModel.post.content = responseObject[@"data"][@"post"][@"content"];
            _postModel.post.picture = responseObject[@"data"][@"post"][@"picture"];
            _postModel.post.location = responseObject[@"data"][@"post"][@"location"];
            

            for (NSDictionary *dict in responseObject[@"data"][@"main"]) {
                GLCommunity_PostMainCommentModel *model = [GLCommunity_PostMainCommentModel mj_objectWithKeyValues:dict];
                
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

- (void)pushController {
    self.hidesBottomBarWhenPushed = YES;
    GLCommentListController *commentListVC = [[GLCommentListController alloc] init];
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

        cell.model = _postModel;
        
        return cell;
        
    }else{
        
        GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        cell.model = self.mainCommentArr[indexPath.row - 1];
        
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
        
        return 100;
        
    }else{
        if (self.mainCommentArr.count == 0) {
            return 0;
        }
        GLCommunity_PostMainCommentModel *model = self.mainCommentArr[indexPath.row - 1];
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
