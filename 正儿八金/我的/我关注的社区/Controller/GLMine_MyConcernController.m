//
//  GLMine_MyConcernController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/12/1.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyConcernController.h"
#import "GLCommunityCell.h"
#import "GLCommunity_FollowModel.h"
#import "GLCommunity_DetailController.h"

@interface GLMine_MyConcernController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@end

@implementation GLMine_MyConcernController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我关注的社区";
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunityCell" bundle:nil] forCellReuseIdentifier:@"GLCommunityCell"];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"GLCommunity_Attend_Notification" object:nil];
    
}

- (void)refresh {
    [self getData:YES];
}

- (void)getData:(BOOL)status {
    
    if (status){
        _page = 1;
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"page"] =@(_page);
    
    _loadV=[LoadWaitView addloadview:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 49) tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kFOLLOW_COMMUNITY_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if ([responseObject[@"data"] count] != 0) {
                
                if(status){
                    [self.models removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLCommunity_FollowModel *model = [GLCommunity_FollowModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
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
    [self.tableView.mj_footer endRefreshing];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.models.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLCommunity_FollowModel *model = self.models[indexPath.row];
    model.isHiddenAttendBtn = YES;
    
    GLCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunityCell" forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if ([self.delegate respondsToSelector:@selector(pushControllerWithIndex:)]) {
    //        [self.delegate pushControllerWithIndex:indexPath.row];
    //    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLCommunity_FollowModel *model = self.models[indexPath.row];
    
    GLCommunity_DetailController *detailVC = [[GLCommunity_DetailController alloc] init];
    detailVC.communityID = model.id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - 左滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定取消关注该社区？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if([UserModel defaultUser].loginstatus == NO){
                [MBProgressHUD showError:@"请先登录"];
                return;
            }
            
            GLCommunity_FollowModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"token"] = [UserModel defaultUser].token;
            dic[@"uid"] = [UserModel defaultUser].userId;
            dic[@"group"] = [UserModel defaultUser].groupid;
            dic[@"barid"] = model.id; //社区id
            dic[@"status"] = @2; //关注 取消关注,关注状态 1关注 2取消关注
            dic[@"port"] = @1; //1ios 2安卓 3web 默认1
            
            _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kCONCERN_COMMUNITY_URL paramDic:dic finish:^(id responseObject) {
                
                [self endRefresh];
                [_loadV removeloadview];
                
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                    
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLCommunity_Attend_Notification" object:nil];
                }else{
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
                
            } enError:^(NSError *error) {
                [self endRefresh];
                [_loadV removeloadview];
                [MBProgressHUD showError:error.localizedDescription];
                
            }];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消关注";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
    }
    return _nodataV;
}


@end
