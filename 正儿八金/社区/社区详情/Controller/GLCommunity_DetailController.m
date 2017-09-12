//
//  GLCommunity_DetailController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_DetailController.h"
#import "GLHome_AttentionCell.h"
#import "GLCommunity_PostController.h"

@interface GLCommunity_DetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;//关注按钮
@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@end

@implementation GLCommunity_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"社区详情";

    self.attentBtn.layer.cornerRadius = 5.f;
    self.attentBtn.layer.borderWidth = 1.f;
    self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    
    for (int i = 1; i < 8; i++) {
        NSString *str = [NSString stringWithFormat:@"%zd",i];
        
        GLHome_AttentionModel *model = [[GLHome_AttentionModel alloc] init];
        model.sum = str;
        model.content = [NSString stringWithFormat:@"lldsfjj垃圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------%zd",i];
        model.isHiddenAttendBtn = YES;
        model.isHiddenLandlord = NO;
        [self.dataSourceArr addObject:model];
    }

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
    
    GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell" forIndexPath:indexPath];
    cell.model = self.dataSourceArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLCommunity_PostController *postVc = [[GLCommunity_PostController alloc] init];
    [self.navigationController pushViewController:postVc animated:YES];
   
    
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
