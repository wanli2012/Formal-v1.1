//
//  GLHome_UserController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_UserController.h"
#import "GLHome_UserCell.h"
#import "GLHome_Search_UserModel.h"
#import "GLMine_MyPostController.h"//帖子中心

@interface GLHome_UserController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, copy)NSString *searchContent;//搜索内容

@end

@implementation GLHome_UserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_UserCell" bundle:nil] forCellReuseIdentifier:@"GLHome_UserCell"];
    
    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf searchPost:YES];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf searchPost:NO];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self searchPost:YES];
    
}

- (void)searchPost:(BOOL)status {
    
    if (status) {
        self.page = 1;
    }else{
        _page ++;
    }
    
    NSString *searchStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchContent"];
    
    if (searchStr.length <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].userId;
    dict[@"group"] = [UserModel defaultUser].groupid;
    dict[@"searchname"] = searchStr;
    dict[@"page"] = @(_page);
    dict[@"type"] = @"3";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:kPOST_SEARCH_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (![responseObject[@"data"][@"esther"] isEqual:[NSNull null]]) {
                
                if (status) {
                    [self.models removeAllObjects];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"user"]) {
                    GLHome_Search_UserModel *model = [GLHome_Search_UserModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
            }
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

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.models.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLHome_UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_UserCell" forIndexPath:indexPath];
    
    GLHome_Search_UserModel *model = self.models[indexPath.row];
    
    cell.index = indexPath.row;

    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"帖子中心%zd",indexPath.row);
    
    GLHome_Search_UserModel *model = self.models[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    
    GLMine_MyPostController *myPostVC = [[GLMine_MyPostController alloc] init];
    myPostVC.targetUID = model.mid;
    myPostVC.targetGroupID = model.group_id;
    
    [self.navigationController pushViewController:myPostVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 110);
    }
    return _nodataV;
}

@end
