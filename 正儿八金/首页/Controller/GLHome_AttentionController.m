//
//  GLHome_AttentionController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_AttentionController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionModel.h"

@interface GLHome_AttentionController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@end

@implementation GLHome_AttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];

    for (int i = 0; i < 8; i++) {
        NSString *str = [NSString stringWithFormat:@"%zd",i];
        
        GLHome_AttentionModel *model = [[GLHome_AttentionModel alloc] init];
        model.sum = str;
        model.content = [NSString stringWithFormat:@"lldsfjj垃圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------%zd",i];
        model.isHiddenAttendBtn = NO;
        model.isHiddenLandlord = YES;
        model.isHiddenTitleLabel = NO;
        [self.dataSourceArr addObject:model];
    }
    
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSourceArr[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionModel*model = self.dataSourceArr[indexPath.row];
    
    return model.cellHeight;

}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}
@end
