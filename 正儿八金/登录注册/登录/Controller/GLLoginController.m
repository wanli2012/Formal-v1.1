//
//  GLLoginController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"
#import "UIViewController+WXSTransition.h"


@interface GLLoginController ()

@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)login:(id)sender {
    NSLog(@"登录");
    [self.view endEditing:YES];
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码或ID"];
        return;
    }
    
    if (self.pwdTF.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    
//    NSString *encryptsecret = [RSAEncryptor encryptString:self.scretTf.text publicKey:public_RSA];
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:@{@"userphone":self.phoneTF.text,@"password":self.pwdTF.text} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            [UserModel defaultUser].experience = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"experience"]];
            [UserModel defaultUser].groupid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupid"]];
            [UserModel defaultUser].userId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
            [UserModel defaultUser].number_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"number_name"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].portrait = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"portrait"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].user_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_name"]];
            
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


- (IBAction)registe:(id)sender {

    [self wxs_presentViewController:[[GLRegisterController alloc] init] animationType:WXSTransitionAnimationTypePageTransition + 11  completion:nil];
    
}
//忘记密码
- (IBAction)forget:(id)sender {
    NSLog(@"忘记密码");
}


@end
