//
//  GLMessageController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMessageController.h"
#import "GLMessageCell.h"

@interface GLMessageController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMessageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMessageCell" bundle:nil] forCellReuseIdentifier:@"GLMessageCell"];
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
    
    GLMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMessageCell" forIndexPath:indexPath];
    
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
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

@end
