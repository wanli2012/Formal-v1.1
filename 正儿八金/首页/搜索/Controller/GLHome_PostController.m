//
//  GLHome_PostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_PostController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_Search_MainController.h"
//#import "GLHome_Search_PostModel.h"
#import "GLHome_AttentionModel.h"
#import "GLCommunity_PostController.h"//帖子详情

@interface GLHome_PostController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isUpdate;//是否需要刷新
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, copy)NSString *searchContent;//搜索内容
@property (nonatomic, copy)NSString *sort;//排序

@end

@implementation GLHome_PostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    
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
    
    self.sort = @"2";
    
    [self searchPost:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    dict[@"type"] = @"2";
    dict[@"sort"] = self.sort;
    
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
                for (int i = 0; i < [responseObject[@"data"][@"esther"] count]; i ++) {
                    
                    GLHome_AttentionModel *model = [GLHome_AttentionModel mj_objectWithKeyValues:responseObject[@"data"][@"esther"][i]];
                    model.status = responseObject[@"data"][@"esther"][i][@"follow"];
                    model.isHiddenAttendBtn = YES;
                    model.isHiddenLandlord = YES;
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

//可以获取到父容器的控制器的方法,就是这个黑科技.
- (GLHome_Search_MainController *)Controller:(UIView *)view{
    UIResponder *responder = view;
    //循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[GLHome_Search_MainController class]]) {
            return (GLHome_Search_MainController *)responder;
        }
    }
    return nil;
}

#pragma mark - 排序
- (IBAction)sort:(UIButton *)sender {
    
    [self.firstBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    //话题排序状态 1热门 2新帖 3旧贴 默认2
    if (sender == self.firstBtn) {
        
        self.sort = @"1";
    }else if(sender == self.secondBtn){

        self.sort = @"2";
    }else{
    
        self.sort = @"3";
    }
    
    [self searchPost:YES];
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
    
    GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell" forIndexPath:indexPath];
    
    GLHome_AttentionModel *model = self.models[indexPath.row];
    
    cell.index = indexPath.row;
    cell.model = model;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionModel *model = self.models[indexPath.row];
    return model.cellHeight;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLHome_AttentionModel *model = self.models[indexPath.row];
    GLHome_Search_MainController *homeVC = [self Controller:tableView];
    
    homeVC.hidesBottomBarWhenPushed = YES;
    GLCommunity_PostController *detailVC = [[GLCommunity_PostController alloc] init];
    detailVC.mid = model.mid;
    detailVC.post_id = model.post.post_id;
    detailVC.group_id = model.group_id;
    
    typeof(self)weakSelf = self;
    
    detailVC.block = ^(NSString *praise,NSString *fablous,NSString *scanNum){
        
        model.post.fabulous = fablous;
        model.post.praise = praise;
        
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath.row inSection:0]; //刷新第0段第2行
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    [homeVC.navigationController pushViewController:detailVC animated:YES];
    homeVC.hidesBottomBarWhenPushed = NO;

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
