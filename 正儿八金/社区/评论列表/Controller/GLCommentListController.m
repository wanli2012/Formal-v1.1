//
//  GLCommentListController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommentListController.h"
#import "GLCommentCell.h"
#import "GLCommentListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLCommentListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//主评论内容
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//主评论头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//主评论名字
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//主评论日期
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//评论按钮



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论View
@property (weak, nonatomic) IBOutlet UITextField *commentTF;

@property (nonatomic, strong)GLCommentListModel *model;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
//@property (nonatomic,strong)NodataView *nodataV;


@end

@implementation GLCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommentCell"];
    
    
//    [self.tableView addSubview:self.nodataV];
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
    
//    [self.tableView.mj_header beginRefreshing];
    [self getData:YES];
    
}
//为头视图赋值
- (void)setHeader{

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.portrait] placeholderImage:[UIImage imageNamed:@"头像1"]];
    self.nameLabel.text = self.model.user_name;
    self.dateLabel.text = [formattime formateTimeOfDate:self.model.commenttiem];
    self.commentLabel.text = self.model.content;
    [self.priseBtn setTitle:self.model.reply_laud forState:UIControlStateNormal];
    [self.commentBtn setTitle:self.model.reply_publish forState:UIControlStateNormal];
    
    CGSize titleSize = [self.model.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    self.headerView.height = 80 + titleSize.height;
    
    self.commentView.alpha = 0;
    
}

//获取数据
- (void)getData:(BOOL)status {
    
    if (status){
        _page = 1;
        [self.dataSource removeAllObjects];
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_id"] = self.user_id;
    dic[@"post_id"] = self.post_id;
    dic[@"comm_id"] = self.comm_id;
    dic[@"group_id"] = self.group_id;
    dic[@"page"] =@(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kGET_SECOND_COMMENT_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            
            self.model = [GLCommentListModel mj_objectWithKeyValues:responseObject[@"data"]];

            [self setHeader];//为头视图赋值
            
            for (commentModel *model in self.model.post) {
                
                [self.dataSource addObject:model];
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

//-(NodataView*)nodataV{
//    
//    if (!_nodataV) {
//        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
//        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49 - 49);
//    }
//    return _nodataV;
//    
//}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)readThePost:(id)sender {
    NSLog(@"查看原帖子");
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.dataSource.count <= 0 ) {
//        self.nodataV.hidden = NO;
//    }else{
//        self.nodataV.hidden = YES;
//    }

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommentCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.model = self.model.post[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.commentView.alpha = 1;
    [self.commentTF becomeFirstResponder];
    
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
