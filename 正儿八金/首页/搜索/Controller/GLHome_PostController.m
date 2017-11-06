//
//  GLHome_PostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_PostController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_SearchController.h"
#import "GLHome_Search_PostModel.h"

@interface GLHome_PostController ()
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"GLHome_SearchNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isUpdate) {
        [self searchPost:YES];
        _isUpdate = NO;
    }
}

- (void)refresh:(NSNotification *)notification{
    _isUpdate = YES;
    self.searchContent = notification.userInfo[@"searchContent"];
}

- (void)searchPost:(BOOL)status {
    
    if (status) {
        self.page = 1;
    }else{
        _page ++;
    }
    
    NSString *searchStr = [self Controller:self.view].searchTF.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (searchStr.length <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return;
    }
    
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].userId;
    dict[@"group"] = [UserModel defaultUser].groupid;
    dict[@"searchname"] = self.searchContent;
    dict[@"page"] = @(_page);
    dict[@"type"] = @"2";
    dict[@"sort"] = @"2";
    
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
                for (NSDictionary *dic  in responseObject[@"data"][@"esther"]) {
                    GLHome_Search_PostModel *model = [GLHome_Search_PostModel mj_objectWithKeyValues:dic];
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

#pragma mark - 关注
//- (void)attent:(NSInteger)index{
//    
//    if([UserModel defaultUser].loginstatus == NO){
//        [MBProgressHUD showError:@"请先登录"];
//        return;
//    }
//    
//    GLHome_AttentionModel *model = self.models[index];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"uid"] = [UserModel defaultUser].userId;
//    dic[@"group"] = [UserModel defaultUser].groupid;
//    dic[@"barid"] = model.id; //社区id
//    dic[@"status"] = @1; //关注 取消关注,关注状态 1关注 2取消关注
//    dic[@"port"] = @1; //1ios 2安卓 3web 默认1
//    
//    _loadV=[LoadWaitView addloadview:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 49) tagert:[self Controller:self.view].view];
//    [NetworkManager requestPOSTWithURLStr:kCONCERN_COMMUNITY_URL paramDic:dic finish:^(id responseObject) {
//        
//        [self endRefresh];
//        [_loadV removeloadview];
//        
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//            
//            model.isAttention = YES;
//            
//            [self.tableView reloadData];
//            
//        }else{
//            
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//    } enError:^(NSError *error) {
//        [self endRefresh];
//        [_loadV removeloadview];
//        [MBProgressHUD showError:error.localizedDescription];
//        
//    }];
//}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//可以获取到父容器的控制器的方法,就是这个黑科技.
- (GLHome_SearchController *)Controller:(UIView *)view{
    UIResponder *responder = view;
    //循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[GLHome_SearchController class]]) {
            return (GLHome_SearchController *)responder;
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
    
    if (sender == self.firstBtn) {
        NSLog(@"热门话题");
    }else if(sender == self.secondBtn){
        NSLog(@"新帖在前");
    }else{
        NSLog(@"旧帖在前");
    }
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
    
        GLHome_Search_PostModel *model = self.models[indexPath.row];
    //    model.isHiddenAttendLabel = YES;
    
    cell.index = indexPath.row;
//    cell.delegate = self;
        cell.search_postModel = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_Search_PostModel *model = self.models[indexPath.row];
    return model.cellHeight;
    
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
