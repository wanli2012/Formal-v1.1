//
//  GLHome_hotController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_hotController.h"
#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionModel.h"

@interface GLHome_hotController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@end

@implementation GLHome_hotController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    
    for (int i = 1; i < 8; i++) {
        NSString *str = [NSString stringWithFormat:@"%zd",i];
        
        GLHome_AttentionModel *model = [[GLHome_AttentionModel alloc] init];
        model.sum = str;
        model.content = [NSString stringWithFormat:@"是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------%zd",i];
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
