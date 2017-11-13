//
//  GLPublish_TopicChooseController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_TopicChooseController.h"
#import "GLPublish_TopicCell.h"

@interface GLPublish_TopicChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@end

@implementation GLPublish_TopicChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择话题";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_TopicCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_TopicCell"];
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
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"page"] =@(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kTOPIC_CHOOSE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if ([responseObject[@"data"] count] == 0) {
                [self.tableView reloadData];
                return;
            }
            
            if(status){
                [self.dataSourceArr removeAllObjects];
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLPublish_CommunityModel *model = [GLPublish_CommunityModel mj_objectWithKeyValues:dic];
                [self.dataSourceArr addObject:model];
            }
            
        }else if([responseObject[@"code"] integerValue] == NO_MORE_CODE){
            if(_page != 1){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        [self.tableView reloadData];
        [SVProgressHUD showWithStatus:error.localizedDescription];
        
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
    
    GLPublish_TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_TopicCell" forIndexPath:indexPath];
    
    cell.model = self.dataSourceArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GLPublish_CommunityModel *model = self.dataSourceArr[indexPath.row];
    self.block(model.topic);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
@end
