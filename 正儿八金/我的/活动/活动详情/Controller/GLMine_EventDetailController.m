//
//  GLMine_EventDetailController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EventDetailController.h"
#import "GLHome_AttentionCollectionCell.h"
#import "GLCommunity_PostCommentCell.h"
#import "GLHome_AttentionModel.h"

@interface GLMine_EventDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    GLHome_AttentionModel *_model;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation GLMine_EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"#关于宝宝首饰的话题评论抽奖啦#";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentCell"];
    
    _model = [[GLHome_AttentionModel alloc] init];
//    _model.sum = @"2";
//    _model.content = [NSString stringWithFormat:@"lldsfjj垃圾袋龙卷风拉丝机放辣椒酸辣粉静安路附近奥拉夫极乐世界分类设计费时代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师分类是------"];
    _model.isHiddenAttendBtn = YES;
    _model.isHiddenLandlord = NO;
    _model.isHiddenTitleLabel = YES;
    
    
    for (int j = 0; j < 4; j ++ ) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
            
            GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
            model.son_commentName = @"你大爷";
            model.son_comment = [NSString stringWithFormat:@"dfsfsf代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间拉伸发链接阿拉斯加冯老师sf哈哈回复%zd",i];
            [arr addObject:model];
        }
        
        GLCommunity_PostCommentModel *model = [[GLCommunity_PostCommentModel alloc] init];
        model.commentArr = arr;
        model.comment = [NSString stringWithFormat:@"我是主代峰峻螺蛳粉连手机分类是否杀戮空间福建省类是否杀戮空间菲利克斯福建省菲利克斯积分拉伸发链接阿拉斯加冯老师评论:我是主评论:我是主评论:我是主评论:我是主评论:%zd",j];
        [self.dataSource addObject:model];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark -
#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:@"图-2"];
    
    return cell;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if([self.model.sum integerValue] == 0){
//        return CGSizeZero;
//    }else if ([self.model.sum integerValue] == 1) {
//        return CGSizeMake(kSCREEN_WIDTH - 30, kSCREEN_WIDTH - 30);
//    }else if([self.model.sum integerValue] == 2){
//        return CGSizeMake((kSCREEN_WIDTH - 35)/2, (kSCREEN_WIDTH - 35)/2);
//    }
    
    return CGSizeMake((kSCREEN_WIDTH - 40)/3, (kSCREEN_WIDTH - 40)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

#pragma mark -
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;

//    return 170;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
