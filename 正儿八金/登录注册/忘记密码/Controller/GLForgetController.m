//
//  GLForgetController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLForgetController.h"

@interface GLForgetController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdEnsureTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottom;

@end

@implementation GLForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.bgViewBottom.constant = 100 *autoSizeScaleY;
    
    self.getCodeBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.getCodeBtn.layer.borderWidth = 1.f;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

//获取验证码
- (IBAction)getCode:(id)sender {
    
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    
    [NetworkManager requestPOSTWithURLStr:kGETCODE_URL paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [MBProgressHUD showSuccess:@"发送成功"];
            
        }else{
            [MBProgressHUD showSuccess:@"发送失败"];
        }
        
    } enError:^(NSError *error) {
        
        [MBProgressHUD showSuccess:error.localizedDescription];
        
    }];
    
}
//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = MAIN_COLOR;
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

//确定
- (IBAction)sumbit:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.pwdTF.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-16位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.pwdTF.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    
    if (self.pwdEnsureTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![self.pwdTF.text isEqualToString:self.pwdEnsureTF.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.codeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @2;
    dic[@"phone"] = self.phoneTF.text;
    dic[@"password"] = self.pwdTF.text;
    dic[@"confirmpwd"] = self.pwdEnsureTF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kFORGET_PWD_URL paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

@end
