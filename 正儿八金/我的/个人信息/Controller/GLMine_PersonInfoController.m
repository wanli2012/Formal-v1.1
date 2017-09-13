//
//  GLMine_PersonInfoController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_SetupCell.h"

@interface GLMine_PersonInfoController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetupCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetupCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetupCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.detailLabel.hidden = NO;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.detailLabel.text = self.valueArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.arrowImageV.hidden = YES;
    }else{
        cell.arrowImageV.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"名字");
        }
            break;
        case 1:
        {
            NSLog(@"账号");
        }
            break;
        case 2:
        {
            NSLog(@"所在位置");
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
        _titleArr = @[@"名字",@"账号",@"所在位置"];
    }
    return _titleArr;
}

- (NSArray *)valueArr{
    if (!_valueArr) {
        _valueArr = @[@"花草树木",@"12345677",@"成都金牛万达写字楼"];
    }
    return _valueArr;
}

@end
