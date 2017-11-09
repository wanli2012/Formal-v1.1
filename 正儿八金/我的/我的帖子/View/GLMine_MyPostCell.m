//
//  GLMine_MyPostCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostCell.h"
#import "GLHome_AttentionCollectionCell.h"
#import "formattime.h"

@interface GLMine_MyPostCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeftContrait;//左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopContrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signImageVLeftContrait;

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//精帖标志ImageV
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//帖子标题
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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheCollectionView)];
//    [self addGestureRecognizer:tap];
}

//- (void)clickTheCollectionView {
//    NSLog(@"dddd---------ddddd");
//}

//评论
- (IBAction)comment:(id)sender {
    
}

- (void)setModel:(GLMine_MyPost *)model{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】",model.title];
    
    if(model.title.length == 0 && [model.elite integerValue] == 1){
        
        self.titleLabel.hidden = YES;
        self.signImageV.hidden = NO;
        
        self.contentLabelTopContrait.constant = 12;
        self.contentLabelLeftContrait.constant = 95;
        self.signImageV.image = [UIImage imageNamed:@"火"];
        self.signImageVLeftContrait.constant = 80;
        
    }else if(model.title.length == 0 && [model.elite integerValue] == 2){
        self.titleLabel.hidden = YES;
        self.signImageV.hidden = YES;
        
        self.contentLabelTopContrait.constant = 12;
        self.contentLabelLeftContrait.constant = 70;

    }else if(model.title.length != 0 && [model.elite integerValue] == 1){
        self.titleLabel.hidden = NO;
        self.signImageV.hidden = NO;
        
        self.contentLabelTopContrait.constant = 38;
        self.contentLabelLeftContrait.constant = 25;
        self.signImageV.image = [UIImage imageNamed:@"火"];
        self.signImageVLeftContrait.constant = 10;

    }else if(model.title.length != 0 && [model.elite integerValue] == 2){
        self.titleLabel.hidden = NO;
        self.signImageV.hidden = YES;
        
        self.contentLabelTopContrait.constant = 38;
        self.contentLabelLeftContrait.constant = 0;

    }
    
    CGFloat collectionHeight = 0.0;
    CGFloat collectionWidth = 0.0;
    if(model.picture.count == 0){
        collectionHeight = 0;
    }else if (model.picture.count == 1) {
        collectionHeight = (kSCREEN_WIDTH - 25)/2 + 20;
        collectionWidth = (kSCREEN_WIDTH - 25)/2 + 20;
    }else if(model.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 25)/2 + 20;
        collectionWidth = kSCREEN_WIDTH;
    }else if (model.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 30)/3 + 20;
        collectionWidth = kSCREEN_WIDTH;
    }else if(model.picture.count > 3 && model.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 30)/3 + 25;
        collectionWidth = kSCREEN_WIDTH;
    }else if(model.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 30)/3 + 30;
        collectionWidth = kSCREEN_WIDTH;
    }

    self.collectionViewWidth.constant = collectionWidth;
    self.collectionViewHeight.constant = collectionHeight;
    self.contentLabel.text = model.content;
    self.dateLabel.text = [formattime formateTimeOfDate2:model.time];
    [self.scanBtn setTitle:model.pv forState:UIControlStateNormal];
    [self.replyBtn setTitle:model.quantity forState:UIControlStateNormal];

    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.model.picture.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell" forIndexPath:indexPath];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.model.picture[indexPath.row]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
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
    
    if(self.model.picture.count == 0){
        return CGSizeZero;
    }else if (self.model.picture.count == 1) {
        return CGSizeMake((kSCREEN_WIDTH - 25)/2, (kSCREEN_WIDTH - 25)/2);
    }else if(self.model.picture.count == 2){
        return CGSizeMake((kSCREEN_WIDTH - 25)/2, (kSCREEN_WIDTH - 25)/2);
    }
    return CGSizeMake((kSCREEN_WIDTH - 30)/3, (kSCREEN_WIDTH - 30)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(clickToBigImage:index:)]) {
        [self.delegate clickToBigImage:self.index index:indexPath.row];
    }
    
}

@end
