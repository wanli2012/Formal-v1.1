//
//  GLMine_MyPostCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostCell.h"
#import "GLHome_AttentionCollectionCell.h"

@interface GLMine_MyPostCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;//浏览量
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;//回复

@end

@implementation GLMine_MyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    
}

- (void)setModel:(GLHome_AttentionModel *)model{
    _model = model;
    
    self.contentLabel.text = model.content;
    
    if ([self.model.sum integerValue] == 0){
        
//        self.collectionViewHeight.constant = 0;
        
    }else if ([self.model.sum integerValue] == 4) {
        
        self.collectionViewWidth.constant = 2 * (kSCREEN_WIDTH - 40)/3 ;
        
    }else{
        
        self.collectionViewWidth.constant = kSCREEN_WIDTH;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.model.sum integerValue];
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
    if([self.model.sum integerValue] == 0){
        return CGSizeZero;
    }else if ([self.model.sum integerValue] == 1) {
        return CGSizeMake(kSCREEN_WIDTH - 30, kSCREEN_WIDTH - 30);
    }else if([self.model.sum integerValue] == 2){
        return CGSizeMake((kSCREEN_WIDTH - 35)/2, (kSCREEN_WIDTH - 35)/2);
    }
    
    return CGSizeMake((kSCREEN_WIDTH - 40)/3, (kSCREEN_WIDTH - 40)/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

@end
