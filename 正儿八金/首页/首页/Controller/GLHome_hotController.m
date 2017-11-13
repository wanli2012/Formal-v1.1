//
//  GLHome_hotController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_hotController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionModel.h"
#import "GLCommunity_PostController.h"
#import "GLHomeController.h"
#import "GLMine_MyPostController.h"
#import "JZAlbumViewController.h"

#import "GLHomePageNoticeView.h"//公告

@interface GLHome_hotController ()<GLHome_AttentionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@property (nonatomic, strong)UIView  *maskV;//遮罩
@property (nonatomic, strong)GLHomePageNoticeView *noticeView;//公告

@end

@implementation GLHome_hotController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    
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
    [self initInterDataSorceinfomessage];//公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"attention_PraiseNotification" object:nil];
    
}
- (void)refresh
{
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
    
    _loadV=[LoadWaitView addloadview:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 84 - 49) tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kHOT_HOME_URL paramDic:dic finish:^(id responseObject) {
        
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
                
                GLHome_AttentionModel *model = [GLHome_AttentionModel mj_objectWithKeyValues:dic];
                
                model.isHiddenAttendBtn = NO;
                model.isHiddenLandlord = YES;
                
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

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark ----公告
-(void)initInterDataSorceinfomessage{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isShow"];//展示过就不要展示了，重启App在调
    
    CGFloat contentViewH = kSCREEN_HEIGHT / 2;
    CGFloat contentViewW = kSCREEN_WIDTH - 40;
    CGFloat contentViewX = 20;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskV];
    [window addSubview:self.noticeView];
    
    [NetworkManager requestPOSTWithURLStr:kNOTICE_URL paramDic:@{@"port":@"2"} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.noticeView.titleLabel.text = responseObject[@"data"][@"title"];
            
            [self.noticeView.webView loadHTMLString:responseObject[@"data"][@"content"] baseURL:nil];

        }
        
    } enError:^(NSError *error) {
       
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    self.noticeView.frame = CGRectMake(contentViewX, (kSCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    //缩放
    self.noticeView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    self.noticeView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.noticeView.alpha = 1;
    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(0.07, 0.07);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.noticeView.center = CGPointMake(kSCREEN_WIDTH - 30,30);
        } completion:^(BOOL finished) {
            [self.noticeView removeFromSuperview];
            [self.maskV removeFromSuperview];
        }];
    }];
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
    
    if([model.post.fabulous isEqualToString:@"1"]){//返回值fabulous:1已关注 2:未关注
        dic[@"type"] = @"2";//参数status:1 点赞   2:取消点赞
    }else{
        dic[@"type"] = @"1";
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_PRISE_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            NSInteger praise = [model.post.praise integerValue];
            //cell刷新
            NSString *fabulous;
            if([model.post.fabulous isEqualToString:@"1"]){//fabulous:1已关注 2:未关注
                fabulous = @"2";
                model.post.praise  = [NSString stringWithFormat:@"%zd",praise - 1];
                [MBProgressHUD showSuccess:@"取消点赞"];
            }else{
                fabulous = @"1";
                model.post.praise  = [NSString stringWithFormat:@"%zd",praise + 1];
                [MBProgressHUD showSuccess:@"点赞+1"];
            }
            
            model.post.fabulous = fabulous;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Hot_isPraiseNotification" object:nil];
            
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
    
    GLHome_AttentionModel *model = self.dataSourceArr[index];
    GLHomeController *homeVC = [self View:self.tableView];
    
    homeVC.hidesBottomBarWhenPushed = YES;
    GLCommunity_PostController *detailVC = [[GLCommunity_PostController alloc] init];
    detailVC.mid = model.mid;
    detailVC.post_id = model.post.post_id;
    detailVC.group_id = model.group_id;
    detailVC.isCommenting = YES;
    
    typeof(self)weakSelf = self;
    
    detailVC.block = ^(NSString *praise,NSString *fablous,NSString *scanNum){
        
        model.post.fabulous = fablous;
        model.post.praise = praise;
        
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index inSection:0]; //刷新第0段第2行
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    [homeVC.navigationController pushViewController:detailVC animated:YES];
    homeVC.hidesBottomBarWhenPushed = NO;

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
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[self View:self.view].view];
    [NetworkManager requestPOSTWithURLStr:kFOLLOW_OR_CANCEL_URL paramDic:dic finish:^(id responseObject) {
        
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            NSString *statusStr = model.status;
            
            //cell刷新
            if([statusStr isEqualToString:@"1"]){//status:1已关注 2:未关注
                model.status = @"2";
                [MBProgressHUD showSuccess:@"取消关注成功"];
            }else{
                model.status = @"1";
                [MBProgressHUD showSuccess:@"关注成功"];
            }
            
            //发送通知,关注动态更新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (int i = 0;i < self.dataSourceArr.count;i++) {
                
                GLHome_AttentionModel *m = self.dataSourceArr[i];
                
                if (m.mid == model.mid) {
                    if([statusStr isEqualToString:@"1"]){//status:1已关注 2:未关注
                        m.status = @"2";
                    }else{
                        m.status = @"1";
                      
                    }
                    
                    [arr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
//            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:index inSection:0]; //刷新第0段第2行
            
            [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];

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
    
    GLHome_AttentionModel*model = self.dataSourceArr[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLHome_AttentionModel *model = self.dataSourceArr[indexPath.row];
    GLHomeController *homeVC = [self View:tableView];
    
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

- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 84 - 49);
    }
    return _nodataV;
}

- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _maskV.backgroundColor = [UIColor blackColor];
        _maskV.alpha = 0.3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismiss)];
        [_maskV addGestureRecognizer:tap];
        
    }
    return _maskV;
}

- (GLHomePageNoticeView *)noticeView{
    if (!_noticeView) {
        
        _noticeView = [[NSBundle mainBundle] loadNibNamed:@"GLHomePageNoticeView" owner:nil options:nil].lastObject;

        _noticeView.contentViewW.constant = kSCREEN_WIDTH - 40;
        _noticeView.contentViewH.constant = kSCREEN_HEIGHT / 2 - 40;
        _noticeView.layer.cornerRadius = 5;
        _noticeView.layer.masksToBounds = YES;
        [_noticeView.cancelBt addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        //设置webView
        _noticeView.webView.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH - 40, 0);
        _noticeView.webView.scalesPageToFit = YES;
        _noticeView.webView.autoresizesSubviews = NO;
        _noticeView.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _noticeView.webView.scrollView.bounces = NO;
        
        _noticeView.webView.backgroundColor = [UIColor clearColor];
        _noticeView.webView.opaque = NO;
        
        [_noticeView.cancelBt setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
    }
    return _noticeView;
}


@end
