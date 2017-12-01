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
#import <SDWebImage/UIImageView+WebCache.h>
#import "JZAlbumViewController.h"
#import "GLCommunity_PostController.h"//帖子详情

@interface GLMine_MyPostController ()<UITableViewDataSource,UITableViewDelegate,GLMine_MyPostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)GLMine_MyPostModel *model;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
//@property (nonatomic,strong)NodataView *nodataV;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;//级别
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageV;//等级图片

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;//关注人数
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *postLabel;//帖子数

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;//是否关注了该用户

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏
@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部功能块
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstrait;

@end

@implementation GLMine_MyPostController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyPostCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyPostCell"];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
    if(self.isHiddenBottomView){
        self.bottomView.hidden = YES;
        self.tableViewBottomConstrait.constant = 0;
    }else{
        self.bottomView.hidden = NO;
        self.tableViewBottomConstrait.constant = 50;
    }

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshInterface" object:nil];
}

#pragma mark - 给头视图赋值
- (void)setHeader {
    
    self.headerView.height = 230;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.portrait] placeholderImage:[UIImage imageNamed:@"图-2"]];
    self.nameLabel.text = self.model.user_name;
    self.gradeLabel.text = self.model.number_name;
    self.attentionLabel.text =[NSString stringWithFormat:@"关注:%@",self.model.follow];
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝:%@",self.model.fans];
    self.postLabel.text = [NSString stringWithFormat:@"帖子:%@",self.model.posts];
    [self.gradeImageV sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    if ([self.model.status integerValue] == 1) {//查看人是否关注被查看人 1关注 2未关注 未登录查看默认2
        [self.statusBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.statusBtn.enabled = NO;
    }else{
        [self.statusBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.statusBtn.enabled = YES;
    }
}

- (void)refresh {
    [self getData:YES];
}

#pragma mark - 获取数据
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
    dic[@"user_id"] = self.targetUID;
    dic[@"user_group"] = self.targetGroupID;
    dic[@"page"] = @(_page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCHECK_INFO_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                return;
            }
            self.model = [GLMine_MyPostModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (status) {
                //设置头视图上的值
                [self setHeader];
                [self.dataSourceArr removeAllObjects];
            }
            
            for (NSDictionary *dict in responseObject[@"data"][@"post"]) {
                GLMine_MyPost *post = [GLMine_MyPost mj_objectWithKeyValues:dict];
                
                [self.dataSourceArr addObject:post];
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
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关注
- (IBAction)attent:(id)sender {
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"user_id"] = self.model.user_id;
    dic[@"status"] = @"1";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kFOLLOW_OR_CANCEL_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.statusBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.statusBtn.enabled = NO;

            //发送通知,关注动态更新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
        }else{
            
           [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

#pragma mark - 查看头像大图
- (IBAction)checkBigPic:(id)sender {
    self.HideNavagation = YES;
    
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = 0;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [NSMutableArray arrayWithArray:@[self.model.portrait]];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];

}

#pragma mark - 查看大图
- (void)clickToBigImage:(NSInteger)cellIndex index:(NSInteger)index{

    GLMine_MyPost * model = self.dataSourceArr[cellIndex];
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString * s in model.picture) {//@"%@?imageView2/1/w/200/h/200",
        //        NSString *str = [NSString stringWithFormat:@"%@?x-oss-process=style/goods_Banne",s];
        [arrM addObject:s];
    }
    jzAlbumVC.imgArr = arrM;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
}

#pragma mark - 删除帖子
- (void)deleteThePost:(NSInteger)cellIndex{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除该帖子吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"uid"] = [UserModel defaultUser].userId;
        dic[@"group"] = [UserModel defaultUser].groupid;
        dic[@"post_id"] = self.model.post[cellIndex].post_id;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kDEL_POST_URL paramDic:dic finish:^(id responseObject) {
            
            [self endRefresh];
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [self.dataSourceArr removeObjectAtIndex:cellIndex];
                [self.tableView reloadData];
              
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [self endRefresh];
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            
        }];

    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.dataSourceArr.count <= 0 ) {
//        self.nodataV.hidden = NO;
//    }else{
//        self.nodataV.hidden = YES;
//    }
//
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyPostCell"];
    
    cell.index = indexPath.row;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyPost *model = self.dataSourceArr[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyPost *model = self.dataSourceArr[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    GLCommunity_PostController *detailVC = [[GLCommunity_PostController alloc] init];
    detailVC.mid = self.model.user_id;
    detailVC.post_id = model.post_id;
    detailVC.group_id = self.targetGroupID;
    
    typeof(self)weakSelf = self;
    
    detailVC.block = ^(NSString *praise,NSString *fablous,NSString *scanNum){
        
        GLMine_MyPost *model = weakSelf.dataSourceArr[indexPath.row];
        
        model.fabulous = fablous;
        model.pv = scanNum;
        
//        [weakSelf.tableView reloadData];
        
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath.row inSection:0]; //刷新第0段第2行
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

//-(NodataView*)nodataV{
//
//    if (!_nodataV) {
//        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
//        _nodataV.frame = CGRectMake(0, 230, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49 - 49);
//    }
//    return _nodataV;
//
//}

@end
