//
//  GLHome_AttentionCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionCollectionCell.h"

@interface GLHome_AttentionCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *landlordBtn;//楼主标志
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题Label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@end

@implementation GLHome_AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = 20;
    self.attentionBtn.layer.cornerRadius = 5.f;

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    

}

- (void)setModel:(GLHome_AttentionModel *)model{
    _model = model;

    self.contentLabel.text = model.content;
    
    if ([self.model.sum integerValue] == 4) {
        
        self.collectionViewWidth.constant = 2 *(kSCREEN_WIDTH - 40)/3 + 36;
        
    }else{
        self.collectionViewWidth.constant = kSCREEN_WIDTH;
    }
    
    //是否隐藏关注按钮
    if (model.isHiddenAttendBtn) {
        self.attentionBtn.hidden = YES;
    }else{
        self.attentionBtn.hidden = NO;
    }
    
    //是否隐藏楼主标志
    if(model.isHiddenLandlord){
        self.landlordBtn.hidden = YES;
    }else{
        self.landlordBtn.hidden = NO;
    }
    
    //是否隐藏标题label
    if (model.isHiddenTitleLabel) {
        self.titleLabelHeight.constant = 0;
    }else{
//        self.titleLabel.height = NO;
        self.titleLabelHeight.constant = 20;
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
    
    if ([self.model.sum integerValue] == 1) {
        return CGSizeMake(kSCREEN_WIDTH - 30, kSCREEN_WIDTH - 30);
    }else if([self.model.sum integerValue] == 2){
        return CGSizeMake((kSCREEN_WIDTH - 35)/2, (kSCREEN_WIDTH - 35)/2);
    }
    
    return CGSizeMake((kSCREEN_WIDTH - 40)/3, (kSCREEN_WIDTH - 40)/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
