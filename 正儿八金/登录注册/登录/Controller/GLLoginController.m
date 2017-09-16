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


@interface GLLoginController ()

@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
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
        
        if ([responseObject[@"code"] integerValue]==105) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            [UserModel defaultUser].experience = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"experience"]];
            [UserModel defaultUser].groupid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
            [UserModel defaultUser].userId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
            [UserModel defaultUser].number_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"number_name"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].portrait = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"portrait"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].user_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_name"]];
             
            [UserModel defaultUser].loginstatus = YES;
            [usermodelachivar achive];
        
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

//注册
- (IBAction)registe:(id)sender {

    [self wxs_presentViewController:[[GLRegisterController alloc] init] animationType:WXSTransitionAnimationTypePageTransition + 11  completion:nil];
    
}
//忘记密码
- (IBAction)forget:(id)sender {

    [self.navigationController pushViewController:[[GLForgetController alloc] init] animated:YES];

}


@end
