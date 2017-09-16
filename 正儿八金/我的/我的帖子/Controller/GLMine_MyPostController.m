//
//  GLMine_MyPostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostController.h"
#import "GLMine_MyPostCell.h"
#import "GLMine_MyPostModel.h"

@interface GLMine_MyPostController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@property (strong, nonatomic)LoadWaitView *loadV;


@end

@implementation GLMine_MyPostController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyPostCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyPostCell"];
    
    for (int i = 0; i < 8; i++) {
        NSString *str = [NSString stringWithFormat:@"%zd",i];
        
        GLMine_MyPostModel *model = [[GLMine_MyPostModel alloc] init];
        model.sum = str;
        model.content = [NSString stringWithFormat:@"圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------%zd",i];
 
        [self.dataSourceArr addObject:model];
    }
    
    [self getData];
}

- (void)getData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = @"1";
    dic[@"user_id"] = [UserModel defaultUser].userId;
    dic[@"user_group"] = @"1";
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCHECK_INFO_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==105) {
        
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyPostCell"];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyPostModel *model = self.dataSourceArr[indexPath.row];
    
    return model.cellHeight;
    
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}
@end
