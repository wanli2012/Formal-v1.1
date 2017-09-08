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

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLHome_AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageV.layer.cornerRadius = 20;
    self.attentionBtn.layer.cornerRadius = 5.f;
    
//    if (self.sum <= 3 && self.sum  > 0) {
//        self.collectionViewHeight.constant = kSCREEN_WIDTH - 20;
//    }else if(self.sum > 3 && self.sum <= 6){
//        self.collectionViewHeight.constant = (kSCREEN_WIDTH - 30)/2;
//    }else if (self.sum > 6){
//        self.collectionViewHeight.constant = 340;
//    }
   
//    NSLog(@"%f",self.collectionViewHeight.constant);
    
//    [self layoutIfNeeded];

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    
}

- (void)setModel:(GLHome_AttentionModel *)model{
    _model = model;

    self.contentLabel.text = model.content;
    
    if ([self.model.sum integerValue] == 4) {
        self.collectionViewWidth.constant = 2 *(kSCREEN_WIDTH - 30)/3 + 26;
    }else{
        self.collectionViewWidth.constant = kSCREEN_WIDTH;
    }
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLHome_AttentionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell" forIndexPath:indexPath];

    cell.imageV.image = [UIImage imageNamed:@"图-2"];
    
    if (indexPath.row + 1 > [self.model.sum integerValue]) {
        cell.hidden = YES;
    }
    
    NSLog(@"self.sum = %@",self.model.sum);
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
        return CGSizeMake(kSCREEN_WIDTH - 20, kSCREEN_WIDTH - 20);
    }else if([self.model.sum integerValue] == 2){
        return CGSizeMake((kSCREEN_WIDTH - 25)/2, (kSCREEN_WIDTH - 25)/2);
    }
    
    return CGSizeMake((kSCREEN_WIDTH - 30)/3, (kSCREEN_WIDTH - 30)/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


@end
