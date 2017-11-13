//
//  GLCommunity_DetailController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_DetailController.h"
#import "GLHome_AttentionCell.h"
#import "GLCommunity_PostController.h"
#import "GLCommunity_DetailModel.h"

@interface GLCommunity_DetailController ()<UITableViewDelegate,UITableViewDataSource,GLHome_AttentionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;//关注按钮

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *topPostTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV3;



@property (nonatomic, strong)NSMutableArray *postArr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)GLCommunity_DetailModel *model;

@end

@implementation GLCommunity_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.attentBtn.layer.cornerRadius = 5.f;
    self.attentBtn.layer.borderWidth = 1.f;
    self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
    
    self.imageV.layer.cornerRadius = self.imageV.height / 2;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
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

- (void)getData:(BOOL)status{
    
    if (status) {
        _page = 1;
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"id"] = self.communityID;
    dic[@"condition"] = @"1";
    dic[@"eaiteall"] = @"1";
    dic[@"page"] = @(_page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCOMMUNITY_DETAIL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (status) {
                self.model = nil;
                [self.postArr removeAllObjects];
            }
            
            self.model = [GLCommunity_DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            for (NSDictionary *dic in responseObject[@"data"][@"postdata"]) {
                GLCommunity_Detail_elite *post = [GLCommunity_Detail_elite mj_objectWithKeyValues:dic];
                post.isHiddenAttendBtn = YES;
                post.isHiddenLandlord = YES;
                
                [self.postArr addObject:post];
            }
            
            [self setHeader];//设置透视图
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - 设置透视图
- (void)setHeader{
    
    if(self.model.postbarname.length == 0){
        self.navigationItem.title = @"社区详情";
    }else{
        self.navigationItem.title = self.model.postbarname;//吧名
    }

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.model.postbar_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.postNumLabel.text = [NSString stringWithFormat:@"主贴:%@",self.model.totalnum];
    self.attendNumLabel.text = [NSString stringWithFormat:@"关注人数:%@",self.model.carenum];
    
    if(self.model.toppost.title.length == 0){
        self.topPostTitleLabel.text = @"暂无";
    }else{
        self.topPostTitleLabel.text = [NSString stringWithFormat:@"%@",self.model.toppost.title];
    }
    
    if ([self.model.userstatus integerValue] == 1) {//用户关注1:已关注 2:未关注
        self.attentBtn.backgroundColor = [UIColor whiteColor];
        [self.attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.attentBtn.layer.cornerRadius = 5.f;
        self.attentBtn.layer.borderWidth = 1.f;
        self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
        
        self.model.userstatus = @"1";
        self.attentBtn.enabled = NO;
        
    }else{
        
        self.attentBtn.backgroundColor = MAIN_COLOR;
        [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentBtn setTitle:@"加关注" forState:UIControlStateNormal];
        self.model.userstatus = @"2";
        self.attentBtn.enabled = YES;
    }
    
    if (self.model.users.count == 0) {
        
        self.picImageV.hidden = YES;
        self.picImageV2.hidden = YES;
        self.picImageV3.hidden = YES;
        
    }else if(self.model.users.count > 0){
        self.picImageV.hidden = NO;
        [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.users[0].header_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        
        if(self.model.users.count > 1){
            self.picImageV2.hidden = NO;
            [self.picImageV2 sd_setImageWithURL:[NSURL URLWithString:self.model.users[1].header_pic ] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
            
            if(self.model.users.count > 2){
                self.picImageV3.hidden = NO;
                [self.picImageV3 sd_setImageWithURL:[NSURL URLWithString:self.model.users[2].header_pic ] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
                
                if(self.model.users.count > 3){
                    return;
                    
//                    [self.picImageV2 sd_setImageWithURL:[NSURL URLWithString:self.model.users[4].header_pic ] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
                }
            }
        }
    }
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 查看活跃用户的个人信息
- (IBAction)checkPersoninfo:(UITapGestureRecognizer *)tap {
    
    if(tap.view.tag == 11){
        NSLog(@"个人信息  1");
    }else if(tap.view.tag == 12){
        NSLog(@"个人信息  2");
    }else{
        NSLog(@"个人信息  3");
    }
}

#pragma mark - 查看精帖
- (IBAction)checkPost:(id)sender {
    NSLog(@"查看精帖");
}

#pragma mark - 排序
- (IBAction)sort:(id)sender {
    NSLog(@"排序");
}

#pragma mark - 关注
- (IBAction)attend:(id)sender {
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"barid"] = self.communityID;
    dic[@"port"] = @"1";
    
    if([self.model.userstatus isEqualToString:@"1"]){//返回值status:1已关注 2:未关注
        dic[@"status"] = @"2";//参数status:1 关注   2:取消关注
    }else{
        dic[@"status"] = @"1";//参数status:1 关注   2:取消关注
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kATTEND_COMMUNITY_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            NSString *statusStr = self.model.userstatus;
            
            //cell刷新
            if([statusStr isEqualToString:@"1"]){//status:1已关注 2:未关注
                self.attentBtn.backgroundColor = MAIN_COLOR;
                [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.attentBtn setTitle:@"关注" forState:UIControlStateNormal];
                self.model.userstatus = @"2";
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
                
            }else{
                [self.attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
                self.attentBtn.backgroundColor = [UIColor whiteColor];
                [self.attentBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                self.attentBtn.layer.cornerRadius = 5.f;
                self.attentBtn.layer.borderWidth = 1.f;
                self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
                
                self.attentBtn.enabled = NO;
                self.model.userstatus = @"1";
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }
            
            //发送通知,关注动态更新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLCommunity_Attend_Notification" object:nil];
            
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

#pragma mark - 点赞
- (void)praise:(NSInteger)index{
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    GLCommunity_Detail_elite *model = self.postArr[index];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"postid"] = model.post.post_id;
    dic[@"port"] = @"1";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            NSString *statusStr = self.model.userstatus;
            //cell刷新
            if([statusStr isEqualToString:@"1"]){//status:1已关注 2:未关注
                self.model.userstatus = @"2";
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }else{
                self.model.userstatus = @"1";
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        [self.tableView reloadData];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.postArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell" forIndexPath:indexPath];
    cell.community_Post = self.postArr[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_Detail_elite *model = self.postArr[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    GLCommunity_PostController *postVc = [[GLCommunity_PostController alloc] init];
    postVc.post_id = model.post.post_id;
    postVc.mid = model.mid;
    postVc.group_id = model.group_id;
    postVc.mark = 2;
    
    __weak __typeof(self) weakSelf = self;
    postVc.block = ^(NSString *comments,NSString *fabulous,NSString *scanNum){
        
        GLCommunity_Detail_elite *model = weakSelf.postArr[indexPath.row];
        model.post.comments = comments;
        model.post.pv = scanNum;
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath.row inSection:0]; //刷新第0段第2行
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self.navigationController pushViewController:postVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     GLCommunity_Detail_elite *model = self.postArr[indexPath.row];
    return model.cellHeight;
}

- (NSMutableArray *)postArr{
    if (!_postArr) {
        _postArr = [[NSMutableArray alloc] init];
    }
    return _postArr;
}

@end
