//
//  GLHome_AttentionCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_AttentionCell.h"
#import "GLHome_AttentionCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLHome_AttentionCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *landlordBtn;//楼主标志
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题Label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;


@property (nonatomic, assign)BOOL isHiddenAttendBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;//点赞
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//评论
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;//地址

@end

@implementation GLHome_AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = 20;
    self.attentionBtn.layer.cornerRadius = 5.f;

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    
    [self.picImageV addGestureRecognizer:tap];
    [self.nameLabel addGestureRecognizer:tap2];
    
}


- (void)setModel:(GLHome_AttentionModel *)model{
    
    _model = model;
    
    self.nameLabel.text = model.user_name;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"头像1"]];
    
    self.communityLabel.text = [formattime formateTime:model.post.time];
    
    self.titleLabel.text = model.post.title;
    self.contentLabel.text = model.post.content;
    
    [self.praiseBtn setTitle:model.post.praise forState:UIControlStateNormal];
    [self.commentBtn setTitle:model.post.quantity forState:UIControlStateNormal];
    [self.addressBtn setTitle:model.post.location forState:UIControlStateNormal];
    
    if([model.status integerValue] == 1){//已关注
        
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.attentionBtn.backgroundColor = [UIColor whiteColor];
        self.attentionBtn.layer.borderColor = MAIN_COLOR.CGColor;
        self.attentionBtn.layer.borderWidth = 1.f;
        
    }else{
        
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.attentionBtn.backgroundColor = MAIN_COLOR;
    }
    
    if ([model.fabulous integerValue] == 1) {//已点赞
        
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
        
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    if (model.post.picture.count == 4) {
        
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
        
        self.titleLabelHeight.constant = 20;
    }
    
    
    [self.collectionView reloadData];
}

- (void)setPostModel:(GLCommunity_PostCommentModel *)postModel{
    _postModel = postModel;
    
    self.nameLabel.text = postModel.user_name;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:postModel.portrait] placeholderImage:[UIImage imageNamed:@"头像1"]];
    
//    NSDictionary *dic = (NSDictionary *)postModel.post;
    self.communityLabel.text = [formattime formateTimeOfDate:[NSString stringWithFormat:@"%@",postModel.post.time]];
    
    self.titleLabel.text = postModel.post.title;
    self.contentLabel.text = postModel.post.content;
    
    [self.praiseBtn setTitle:postModel.post.pv forState:UIControlStateNormal];
    [self.commentBtn setTitle:postModel.post.praise forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"浏览"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    
    [self.addressBtn setTitle:postModel.post.location forState:UIControlStateNormal];


    if ([postModel.post.picture count] == 4) {
        
        self.collectionViewWidth.constant = 2 *(kSCREEN_WIDTH - 40)/3 + 36;
        
    }else{
        
        self.collectionViewWidth.constant = kSCREEN_WIDTH;
    }
    //是否隐藏关注按钮
    if (postModel.isHiddenAttendBtn) {
        self.attentionBtn.hidden = YES;
    }else{
        self.attentionBtn.hidden = NO;
    }
    
    //是否隐藏楼主标志
    if(postModel.isHiddenLandlord){
        self.landlordBtn.hidden = YES;
    }else{
        self.landlordBtn.hidden = NO;
    }
    
    //是否隐藏标题label
    if (postModel.isHiddenTitleLabel) {
        self.titleLabelHeight.constant = 0;
    }else{
        
        self.titleLabelHeight.constant = 20;
    }
    
    [self.collectionView reloadData];
}
#pragma mark - GLHomeAttentionCellDelegate
//评论
- (IBAction)comment:(id)sender {

    if ([self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.index];
    }
}

//点赞
- (IBAction)praise:(id)sender {
 
    if ([self.delegate respondsToSelector:@selector(praise:)]) {
        [self.delegate praise:self.index];
    }
}

- (void)personInfo {
    if ([self.delegate respondsToSelector:@selector(personInfo:)]) {
        [self.delegate personInfo:self.index];
    }
}
- (IBAction)follow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(follow:)]) {
        [self.delegate follow:self.index];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.postModel?self.postModel.post.picture.count:self.model.post.picture.count;
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
