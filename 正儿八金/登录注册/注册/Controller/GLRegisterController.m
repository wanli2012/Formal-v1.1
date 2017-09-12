//
//  GLRegisterController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"

@interface GLRegisterController ()
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册
@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.getCodeBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.getCodeBtn.layer.borderWidth = 1.f;
    
    self.view.width = kSCREEN_WIDTH;
    self.view.height = kSCREEN_HEIGHT;
    
}

//获取验证码
- (IBAction)getCode:(id)sender {
    NSLog(@"获取验证码");
}

- (IBAction)login:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registe:(id)sender {
    NSLog(@"注册");
}


@end
