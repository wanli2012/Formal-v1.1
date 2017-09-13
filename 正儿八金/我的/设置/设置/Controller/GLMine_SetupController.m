//
//  GLMine_SetupController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetupController.h"
#import "GLMine_SetupCell.h"

@interface GLMine_SetupController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSArray *titleArr;

@end

@implementation GLMine_SetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"系统设置";
     [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetupCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetupCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)signOut:(id)sender {
    NSLog(@"退出登录");
}

#pragma mark -
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetupCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"账号安全");
        }
            break;
        case 1:
        {
            NSLog(@"隐私");
        }
            break;
        case 2:
        {
            NSLog(@"帮助与反馈");
        }
            break;
        case 3:
        {
            NSLog(@"清除缓存");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark lazy

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"账号安全",@"隐私",@"帮助与反馈",@"清除缓存"];
    }
    return _titleArr;
}

@end
