//
//  GLPublish_CommunityChooseController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_CommunityChooseController.h"
#import "GLPublish_CommunityCell.h"

@interface GLPublish_CommunityChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLPublish_CommunityChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择发布的社区";

    [self.tableView registerNib:[UINib nibWithNibName:@"GLPublish_CommunityCell" bundle:nil] forCellReuseIdentifier:@"GLPublish_CommunityCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLPublish_CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLPublish_CommunityCell" forIndexPath:indexPath];
    
//    cell.titleLabel.text = self.dataSource[indexPath.row];
//    cell.index = indexPath.row;
//    
//    cell.attentBtn.hidden = YES;
//    cell.attentLabel.hidden = NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"买菜社区:%zd",indexPath.row);
    self.block(@"hahhah");
    
    [self.navigationController popViewControllerAnimated:YES];
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

@end
