//
//  GLMine_EventController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EventController.h"
#import "GLMine_EventOnLineController.h"
#import "GLMine_EventOffLineController.h"

@interface GLMine_EventController ()

@property (weak, nonatomic) IBOutlet UIButton *onLineBtn;

@property (weak, nonatomic) IBOutlet UIButton *offLineBtn;

@property (nonatomic, strong)GLMine_EventOnLineController *onLineVC;//线上活动

@property (nonatomic, strong)GLMine_EventOffLineController *offLineVC;//线下活动

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIViewController *currentViewController;

@end

@implementation GLMine_EventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"活动"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.onLineBtn setTitle:[NSString stringWithFormat:@"线上活动"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden = NO;
    
    [self setNav];
    
    _onLineVC = [[GLMine_EventOnLineController alloc]init];
    _offLineVC = [[GLMine_EventOffLineController alloc]init];

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, kSCREEN_HEIGHT - 40)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_onLineVC];
    [self addChildViewController:_offLineVC];

    self.currentViewController = _onLineVC;
    [self fitFrameForChildViewController:_onLineVC];
    [self.contentView addSubview:_onLineVC.view];
    
    [self buttonEvent:self.onLineBtn];

}

- (void)setNav{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [button setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)message {
    NSLog(@"消息");
}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//按钮点击事件
- (IBAction)buttonEvent:(UIButton *)sender {
    
    [self.onLineBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.offLineBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  
    [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    if (sender == self.onLineBtn) {
        
        [self transitionFromVC:self.currentViewController toviewController:self.onLineVC];
        [self fitFrameForChildViewController:self.onLineVC];
        
    }else{
        
        [self transitionFromVC:self.currentViewController toviewController:self.offLineVC];
        [self fitFrameForChildViewController:self.offLineVC];
        
    }
}


- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
}
@end
