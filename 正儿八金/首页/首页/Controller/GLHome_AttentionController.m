//
//  GLHome_AttentionController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_AttentionController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionModel.h"
#import "GLHomeController.h"
#import "GLCommunity_PostController.h"
#import "GLMine_MyPostController.h"
#import "JZAlbumViewController.h"

@interface GLHome_AttentionController ()<UITableViewDelegate,UITableViewDataSource,GLHome_AttentionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLHome_AttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"Hot_isPraiseNotification" object:nil];
   
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    dic[@"page"] =@(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kATTENTION_HOME_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if ([responseObject[@"data"] count] == 0) {
                
                [self.tableView reloadData];
                
                return;
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GLHome_AttentionModel *model = [GLHome_AttentionModel mj_objectWithKeyValues:dic];
                
                model.isHiddenAttendBtn = YES;
                model.isHiddenLandlord = YES;
                model.isHiddenTitleLabel = NO;
                
                [self.dataSourceArr addObject:model];
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

#pragma mark - 查看大图
- (void)clickToBigImage:(NSInteger)cellIndex index:(NSInteger)index{
    
    GLHome_AttentionModel *model = self.dataSourceArr[cellIndex];
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString * s in model.post.picture) {//@"%@?imageView2/1/w/200/h/200",
        //        NSString *str = [NSString stringWithFormat:@"%@?x-oss-process=style/goods_Banne",s];
        [arrM addObject:s];
    }
    jzAlbumVC.imgArr = arrM;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
}
#pragma mark - GLHomeAttentionCellDelegate
- (void)praise:(NSInteger)index{
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }

    GLHome_AttentionModel *model = self.dataSourceArr[index];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"postid"] = model.post.post_id;
    dic[@"port"] = @"1";//1:ios 2:安卓 3:web 默认1

    if([model.post.fabulous isEqualToString:@"1"]){//返回值status:1已关注 2:未关注
        dic[@"type"] = @"2";//参数status:1 点赞   2:取消点赞
    }else{
        dic[@"type"] = @"1";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            NSInteger praise = [model.post.praise integerValue];
            //cell刷新
            if([model.post.fabulous isEqualToString:@"1"]){//fabulous:1已关注 2:未关注
                model.post.fabulous = @"2";
                model.post.praise  = [NSString stringWithFormat:@"%zd",praise - 1];
                [MBProgressHUD showSuccess:@"取消点赞"];
            }else{
                model.post.fabulous = @"1";
                model.post.praise  = [NSString stringWithFormat:@"%zd",praise + 1];
                [MBProgressHUD showSuccess:@"点赞+1"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"attention_PraiseNotification" object:nil];
            
            [self.tableView reloadData];

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

- (void)comment:(NSInteger)index{
    NSLog(@"评论%zd",index);
}

- (void)personInfo:(NSInteger)index{

    GLHome_AttentionModel *model = self.dataSourceArr[index];
    GLHomeController *homeVC = [self View:self.tableView];
    
    homeVC.hidesBottomBarWhenPushed = YES;
    
    GLMine_MyPostController *detailVC = [[GLMine_MyPostController alloc] init];
    detailVC.targetGroupID = model.group_id;
    detailVC.targetUID = model.mid;
    
    [homeVC.navigationController pushViewController:detailVC animated:YES];
    
    homeVC.hidesBottomBarWhenPushed = NO;
}
- (void)follow:(NSInteger)index{//关注 status:
    
    if([UserModel defaultUser].loginstatus == NO){
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    GLHome_AttentionModel *model = self.dataSourceArr[index];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"user_id"] = model.mid;
    
    if([model.status isEqualToString:@"1"]){//返回值status:1已关注 2:未关注
        dic[@"status"] = @"2";//参数status:1 关注   2:取消关注
    }else{
        dic[@"status"] = @"1";//参数status:1 关注   2:取消关注
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kFOLLOW_OR_CANCEL_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 104) {
            
            
            //cell刷新
            if([model.status isEqualToString:@"1"]){//status:1已关注 2:未关注
                model.status = @"2";
                [MBProgressHUD showSuccess:@"取消关注成功"];
            }else{
                model.status = @"1";
                [MBProgressHUD showSuccess:@"关注成功"];
            }
            
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index inSection:0]; //刷新第0段第2行
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            
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
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSourceArr.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.model = self.dataSourceArr[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionModel *model = self.dataSourceArr[indexPath.row];
    
    return model.cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GLHomeController *homeVC = [self View:tableView];
    GLHome_AttentionModel *model = self.dataSourceArr[indexPath.row];

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

//可以获取到父容器的控制器的方法,就是这个黑科技.
- (GLHomeController *)View:(UIView *)view{
    UIResponder *responder = view;
    //循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[GLHomeController class]]) {
            return (GLHomeController *)responder;
        }
    }
    return nil;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}


@end
