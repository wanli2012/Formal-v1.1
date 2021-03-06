//
//  GLLoginController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"
#import "GLForgetController.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"

@interface GLLoginController ()<UITextFieldDelegate>

@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//账号
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;//密码
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

//适配界面
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnWidth;

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
//适配界面
- (void)Adaptation{
    
    self.bgViewBottom.constant = 100 * autoSizeScaleY;
    self.bgViewHeight.constant = 260 * autoSizeScaleY;
    self.accountViewHeight.constant = 50 * autoSizeScaleY;
    self.passwordViewHeight.constant = 50 * autoSizeScaleY;
    
    self.accountLabel.font = [UIFont systemFontOfSize:14 * autoSizeScaleX];
    self.passwordLabel.font = [UIFont systemFontOfSize:14 * autoSizeScaleY];
    self.phoneTF.font = [UIFont systemFontOfSize:14 * autoSizeScaleY];
    self.pwdTF.font = [UIFont systemFontOfSize:14 * autoSizeScaleY];
    
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 *autoSizeScaleX];
    self.loginBtnWidth.constant = 140 * autoSizeScaleX;
    
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:18 *autoSizeScaleX];
    self.registerBtnWidth.constant = 140 * autoSizeScaleX;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

//退出登录界面
- (IBAction)logOut:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender {
  
    [self.view endEditing:YES];
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else if(![predicateModel valiMobile:self.phoneTF.text]){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    
    if (self.pwdTF.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-16位密码"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];

//    NSString *encryptsecret = [RSAEncryptor encryptString:self.scretTf.text publicKey:public_RSA];
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:@{@"userphone":self.phoneTF.text,@"password":self.pwdTF.text} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == LOGIN_SUCCESS_CODE) {
            
            
            [UserModel defaultUser].experience = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"experience"]];
            [UserModel defaultUser].groupid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
            [UserModel defaultUser].icon = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"icon"]];
            [UserModel defaultUser].userId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
            [UserModel defaultUser].number_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"number_name"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].portrait = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"portrait"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].user_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_name"]];
            [UserModel defaultUser].acc_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"acc_id"]];
            [UserModel defaultUser].cloud_token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"cloud_token"]];
            [UserModel defaultUser].loginstatus = YES;
            [usermodelachivar achive];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self loginChat];
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

-(void)loginChat{

    //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
    //用户APP的帐号体系和 NIM SDK 并没有直接关系
    //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
    //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
    
    [self uploadImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserModel defaultUser].portrait]]]];
    
    [[[NIMSDK sharedSDK] loginManager] login:[UserModel defaultUser].acc_id
                                       token:[UserModel defaultUser].cloud_token
                                  completion:^(NSError *error) {
                                      [_loadV removeloadview];
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = [UserModel defaultUser].acc_id;
                                          sdkData.token     = [UserModel defaultUser].cloud_token;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          
//                                          BasetabbarViewController * mainTab = [[BasetabbarViewController alloc] initWithNibName:nil bundle:nil];
                                          [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                          
//                                          [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//                                          [UIApplication sharedApplication].keyWindow.rootViewController  = mainTab;
                                          
                                      }
                                      else
                                      {
                                          
                                          NSString *toast = [NSString stringWithFormat:@"登录失败"];
                                          [[UIApplication sharedApplication].keyWindow makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
}

#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 0.2);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) wself = self;
    if (success) {
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error && wself) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                    }else{
                        //                        [wself.view makeToast:@"设置头像失败，请重试"
                        //                                     duration:2
                        //                                     position:CSToastPositionCenter];
                    }
                }];
            }else{
                //                [wself.view makeToast:@"图片上传失败，请重试"
                //                             duration:2
                //                             position:CSToastPositionCenter];
            }
        }];
    }else{
        //        [self.view makeToast:@"图片保存失败，请重试"
        //                    duration:2
        //                    position:CSToastPositionCenter];
    }
}
//注册
- (IBAction)registe:(id)sender {

    [self wxs_presentViewController:[[GLRegisterController alloc] init] animationType:WXSTransitionAnimationTypePageTransition + 11  completion:nil];
    
}
//忘记密码
- (IBAction)forget:(id)sender {

    [self.navigationController pushViewController:[[GLForgetController alloc] init] animated:YES];

}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneTF) {
        [self.pwdTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //是否需要判断只能输入数字(手机号码)
    
    
    
    return YES;
}

@end
