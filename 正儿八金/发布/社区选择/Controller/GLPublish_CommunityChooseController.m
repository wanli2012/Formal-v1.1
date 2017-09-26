//
//  GLPublish_CommunityChooseController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_CommunityChooseController.h"
#import "GLPublish_CommunityCell.h"
#import "GLPublish_CommunityModel.h"

@interface GLPublish_CommunityChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@end

@implementation GLPublish_CommunityChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择发布的社区";

    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_CommunityCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_CommunityCell"];
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
    
    [self getData:YES];
    
    
}

- (void)getData:(BOOL)status {
    
    if (status){
        _page = 1;
        [self.dataSourceArr removeAllObjects];
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"page"] =@(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGET_ALL_COMMUNITY_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GLPublish_CommunityModel *model = [GLPublish_CommunityModel mj_objectWithKeyValues:dic];
            
                [self.dataSourceArr addObject:model];
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
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSourceArr.count <= 0 ) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLPublish_CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_CommunityCell" forIndexPath:indexPath];

    cell.model = self.dataSourceArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"买菜社区:%zd",indexPath.row);
    GLPublish_CommunityModel *model = self.dataSourceArr[indexPath.row];
    self.block(model.name,model.bar_id);
    
    [self.navigationController popViewControllerAnimated:YES];
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}
@end
