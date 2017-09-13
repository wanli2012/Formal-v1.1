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


@interface GLMine_EventDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLMine_EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"#关于宝宝首饰的话题评论抽奖啦#";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentCell"];
    
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
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

@end
