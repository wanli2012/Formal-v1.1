//
//  GLPublishController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublishController.h"
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"
#import "GLPublish_CommunityChooseController.h"//社区选择
#import "GLPublish_TopicChooseController.h"//话题选择
#import "NIMLocationViewController.h"
#import "NIMKitLocationPoint.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface GLPublishController ()<HXPhotoViewDelegate,UITextViewDelegate,NIMLocationViewControllerDelegate>
{
    NSString *_placeHoler;
}

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;//社区名Label
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;//选择地址Btn
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTextFHeight;//标题高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicTFHeight;//话题输入框高度

@property (weak, nonatomic) IBOutlet UIButton *addTopicBtn;//添加话题 按钮
@property (weak, nonatomic) IBOutlet UIButton *addTitleBtn;//添加title 按钮
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;//内容TextV
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//标题TF
@property (weak, nonatomic) IBOutlet UITextField *topicTF;//话题TF

@property (nonatomic, strong)UIScrollView *photoScrollView;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, copy)NSString *bar_id;//社区id
@property (nonatomic, copy)NSString *location;//发帖位置
@property (nonatomic, copy)NSString *topic;//话题

/**
 *imagearr  图片数组
 */
@property (strong, nonatomic)  NSMutableArray *imagearr;

@property(nonatomic,strong) CLGeocoder * geoCoder;

@end

@implementation GLPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textViewHeight.constant = 120;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_WIDTH + kPhotoViewMargin + 170;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;

    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 0, kSCREEN_WIDTH - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:photoView];
    self.photoView = photoView;
    
    _placeHoler = @"老司机准备飙车了(帖子内容)";
    self.contentTextV.text = _placeHoler;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 9;
        _manager.videoMaxNum = 9;
        _manager.maxNum = 18;
        _manager.saveSystemAblum = NO;

    }
    return _manager;
}

#pragma mark - 返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发表
- (IBAction)publish:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    if (self.communityNameLabel.text.length == 0) {
        GLPublish_CommunityChooseController *communityVC = [[GLPublish_CommunityChooseController alloc] init];
        
        communityVC.block = ^(NSString *name,NSString *bar_id){
            
            self.communityNameLabel.text = name;
            self.bar_id = bar_id;
            
        };
        
        [self.navigationController pushViewController:communityVC animated:YES];
        
    }else{
        
        [self publishPost];
    }
}

#pragma mark - 发表帖子请求
- (void)publishPost{

    if (self.bar_id.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"还没选择发布的社区"];
        return;
    }
//    if (self.location.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"还没选择发布地点"];
//        return;
//    }
    if([self.contentTextV.text isEqualToString:_placeHoler] || [self.contentTextV.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入发布内容"];
        return;
    }
    self.location = @"成都金牛区-万达";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"content"] = self.contentTextV.text;
    dic[@"title"] = self.titleTF.text;
    dic[@"topic"] = self.topic;
    dic[@"bar_id"] = self.bar_id;
    dic[@"location"] = self.location;
    dic[@"port"] = @"1";//1:ios 2:安卓 3:web 默认1
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kPUBLISH_POST_URL] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传

        for (int i = 0; i < self.imagearr.count; i ++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,i];
            NSString *title = [NSString stringWithFormat:@"picture[%zd]",i];
            
            NSData *data = UIImageJPEGRepresentation(self.imagearr[i], 0.2);
            [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
        if (uploadProgress.fractionCompleted == 1.0) {
            [SVProgressHUD dismiss];
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [SVProgressHUD showErrorWithStatus:dic[@"message"]];
        }
        [_loadV removeloadview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 选择地址
- (IBAction)chooseAddress:(UIButton *)sender {

    self.hidesBottomBarWhenPushed = YES;
    NIMLocationViewController *locationVC = [[NIMLocationViewController alloc] initWithNibName:nil bundle:nil];
    locationVC.delegate = self;
    locationVC.sign = 1;
    [self.navigationController pushViewController:locationVC animated:YES];

}

#pragma mark - NIMLocationViewControllerDelegate
- (void)onSendLocation:(NIMKitLocationPoint *)locationPoint{
    
    self.location = [NSString stringWithFormat:@"%@%@%@",locationPoint.mark.locality,locationPoint.mark.subLocality,locationPoint.mark.thoroughfare];
    [self.addressBtn setTitle:self.location forState:UIControlStateNormal];

}

#pragma mark - 添加标题
- (IBAction)addTitle:(UIButton *)sender {
    
    if(sender.isSelected){
        
        [self.addTitleBtn setImage:[UIImage imageNamed:@"title-yes"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.titleTextFHeight.constant = 0;
            self.titleTF.text = nil;
            self.scrollView.y -= 50;
        }];
        
    }else{
        [self.addTitleBtn setImage:[UIImage imageNamed:@"title-no"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.y += 50;
            self.titleTextFHeight.constant = 50;
        }];
    }
    sender.selected = !sender.selected;
    
}

#pragma mark - 选择社区
- (IBAction)chooseCommunity:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    GLPublish_CommunityChooseController *communityVC = [[GLPublish_CommunityChooseController alloc] init];
    
    communityVC.block = ^(NSString *name,NSString * bar_id){
        
        self.communityNameLabel.text = name;
        self.bar_id = bar_id;
    };
    
    [self.navigationController pushViewController:communityVC animated:YES];
}

#pragma mark - 话题选择
- (IBAction)topicChoose:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    GLPublish_TopicChooseController *topicVC = [[GLPublish_TopicChooseController alloc] init];
    topicVC.block = ^(NSString *topic){
        self.topicTFHeight.constant = 50;
        self.topic = topic;
        self.topicTF.text = [NSString stringWithFormat:@"#%@#",topic];
        self.scrollView.y = 50 + self.scrollView.y;
    };
    
    [self.navigationController pushViewController:topicVC animated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView.text.length < 1){
        textView.text = _placeHoler;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:_placeHoler]){
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark - 照片选择器 代理
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    [self.imagearr removeAllObjects];
    
    for (HXPhotoModel *photo in photos) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        __weak typeof(self) weakself = self;
        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //设置图片
                [weakself.imagearr insertObject:result atIndex:0];
        }];
    }
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}

#pragma mark - 懒加载
-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"发表图片"], nil];
    }
    return _imagearr;
}

@end
