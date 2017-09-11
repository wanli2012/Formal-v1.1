//
//  GLCommunity_FollowController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_FollowController.h"
#import "GLCommunityCell.h"


@interface GLCommunity_FollowController ()

@end

@implementation GLCommunity_FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunityCell" bundle:nil] forCellReuseIdentifier:@"GLCommunityCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunityCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    
    cell.attentBtn.hidden = YES;
    cell.attentLabel.hidden = NO;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"买菜社区:%zd",indexPath.row);
    
    if ([self.delegate respondsToSelector:@selector(pushControllerWithIndex:)]) {
        [self.delegate pushControllerWithIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

@end
