//
//  GLHome_UserController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_UserController.h"
#import "GLHome_UserCell.h"

@interface GLHome_UserController ()<GLHome_UserCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLHome_UserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_UserCell" bundle:nil] forCellReuseIdentifier:@"GLHome_UserCell"];
    
    
}
#pragma mark - GLHome_UserCellDelegate
- (void)attent:(NSInteger)index{
    NSLog(@"-------关注  %zd",index);
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (self.models.count <= 0 ) {
//        self.nodataV.hidden = NO;
//    }else{
//        self.nodataV.hidden = YES;
//    }
    
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLHome_UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_UserCell" forIndexPath:indexPath];
    
//    GLCommunity_RecommendModel *model = self.models[indexPath.row];
//    model.isHiddenAttendLabel = YES;
    
    cell.index = indexPath.row;
    cell.delegate = self;
//    cell.recommendModel = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

@end
