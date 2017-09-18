//
//  GLMine_MyPostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostController.h"
#import "GLMine_MyPostCell.h"
#import "GLMine_MyPostModel.h"

@interface GLMine_MyPostController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)NSDictionary *dataDic;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;//级别
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;//关注人数
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *postLabel;//帖子数




@end

@implementation GLMine_MyPostController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyPostCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyPostCell"];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshInterface" object:nil];
    
    //设置头视图上的值
    [self setHeader];
    
}
- (void)setHeader {
    
    self.nameLabel.text = self.dataDic[@"user_name"];
    self.gradeLabel.text = self.dataDic[@"number_name"];
    self.attentionLabel.text = self.dataDic[@"follow"];
    self.fansLabel.text = self.dataDic[@"fans"];
    self.postLabel.text = self.dataDic[@"posts"];
}
- (void)refresh {
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
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"user_id"] = self.targetUID;
    dic[@"user_group"] = self.targetGroupID;
    dic[@"page"] = @(_page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCHECK_INFO_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            self.dataDic = responseObject[@"data"];
            
            for (NSDictionary *dic in responseObject[@"data"][@"post"]) {
            
                GLMine_MyPostModel *model = [GLMine_MyPostModel mj_objectWithKeyValues:dic];

                [self.dataSourceArr addObject:model];
            }
            
            [self.tableView reloadData];
            
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

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyPostCell"];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyPostModel *model = self.dataSourceArr[indexPath.row];
    
    return model.cellHeight;
    
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
@end
