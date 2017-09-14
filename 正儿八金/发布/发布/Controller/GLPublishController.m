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

static const CGFloat kPhotoViewMargin = 12.0;

@interface GLPublishController ()<HXPhotoViewDelegate,UITextViewDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *addTitleBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;


@end

@implementation GLPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textViewHeight.constant = 120;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_WIDTH + kPhotoViewMargin + 130;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;

    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 0, kSCREEN_WIDTH - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    _placeHoler = @"老司机准备飙车了";
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

//返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发表
- (IBAction)publish:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    if (self.communityNameLabel.text.length == 0) {
        GLPublish_CommunityChooseController *communityVC = [[GLPublish_CommunityChooseController alloc] init];
        
        communityVC.block = ^(NSString *name){
            
            self.communityNameLabel.text = name;
            
        };
        
        [self.navigationController pushViewController:communityVC animated:YES];
        
    }else{
        
        NSLog(@"发表");
    }
    
}

//选择地址
- (IBAction)chooseAddress:(id)sender {
    NSLog(@"选择地址");
}
//添加标题
- (IBAction)addTitle:(id)sender {
    
    [self.addTitleBtn setImage:[UIImage imageNamed:@"title-yes"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.titleTextFHeight.constant = 50;
    }];
    
    
}
//选择社区
- (IBAction)chooseCommunity:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    GLPublish_CommunityChooseController *communityVC = [[GLPublish_CommunityChooseController alloc] init];
    
    communityVC.block = ^(NSString *name){
        
        self.communityNameLabel.text = name;
        
    };
    
    [self.navigationController pushViewController:communityVC animated:YES];
    
}

//话题选择
- (IBAction)topicChoose:(id)sender {
     NSLog(@"话题选择");
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView.text.length < 1){
        textView.text = _placeHoler;
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:_placeHoler]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark-
#pragma mark HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
//    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
//    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
//    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}

@end
