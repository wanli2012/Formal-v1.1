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

#define bigSpace 15
#define smallSpace 5

@interface GLHome_AttentionCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *landlordBtn;//楼主标志
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题Label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopConstrait;//内容label顶部约束

@property (nonatomic, assign)BOOL isHiddenAttendBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelRightConstait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *eliteImageV;//精华帖标志 1是精华帖 2不是精华帖

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;//点赞
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//评论
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;//地址

@end

@implementation GLHome_AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
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
    
    if (model.user_name.length == 0) {
        self.nameLabel.text = model.phone;
    }else{
        self.nameLabel.text = model.user_name;
    }
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.communityLabel.text = [formattime formateTime:model.post.time];
    
    self.titleLabel.text = model.post.title;
    
    if (model.post.topic.length == 0) {
        self.contentLabel.text = model.post.content;
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"#%@# %@",model.post.topic,model.post.content];
    }
    
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
    
    if ([model.post.fabulous integerValue] == 1) {//已点赞
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    CGFloat collectionHeight = 0.0;
    CGFloat collectionWidth = 0.0;
    collectionWidth = kSCREEN_WIDTH;
    if(model.post.picture.count == 0){
        collectionHeight = 0;
    }else if(model.post.picture.count == 1) {
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
        collectionWidth = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if(model.post.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if (model.post.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
    }else if(model.post.picture.count > 3 && model.post.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
    }else if(model.post.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
    }

    self.collectionViewHeight.constant = collectionHeight;
    self.collectionViewWidth.constant = collectionWidth;
    
    //如果没有地址,隐藏按钮
    if(model.post.location.length == 0){
        self.addressBtn.hidden = YES;
        
    }else{
        self.addressBtn.hidden = NO;
        [self.addressBtn setTitle:model.post.location forState:UIControlStateNormal];
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
    if (model.post.title.length == 0) {
        self.titleLabel.hidden = YES;
        self.contentLabelTopConstrait.constant = 10;
        self.eliteImageV.hidden = YES;
    }else{
        //是否显示精华帖标志
        if ([model.post.elite integerValue] == 1) {//1是精华帖 2不是精华帖
            self.eliteImageV.hidden = NO;
            self.titleLabelRightConstait.constant = 37;
        }else{
            self.eliteImageV.hidden = YES;
            self.titleLabelRightConstait.constant = 10;
        }
        self.titleLabel.hidden = NO;
        self.contentLabelTopConstrait.constant = 35;
    }
    
    [self.collectionView reloadData];
}

- (void)setPostModel:(GLCommunity_PostCommentModel *)postModel{
    _postModel = postModel;
    
    if (postModel.user_name.length == 0) {
        self.nameLabel.text = postModel.phone;
    }else{
        self.nameLabel.text = postModel.user_name;
    }
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:postModel.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.communityLabel.text = [formattime formateTimeOfDate:[NSString stringWithFormat:@"%@",postModel.post.time]];
    
    self.titleLabel.text = postModel.post.title;
    
    self.contentLabel.text = postModel.post.content;
    
    if(postModel.post.pv.length == 0){
        [self.praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setTitle:postModel.post.pv forState:UIControlStateNormal];
    }
    
    [self.commentBtn setTitle:postModel.post.praise forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"浏览"] forState:UIControlStateNormal];
    
    if ([self.postModel.post.fabulous integerValue] == 1) {//已点赞
        [self.commentBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
    }else{
        [self.commentBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    CGFloat collectionHeight = 0.0;
    CGFloat collectionWidth = 0.0;
    collectionWidth = kSCREEN_WIDTH;
    if(postModel.post.picture.count == 0){
        collectionHeight = 0;
    }else if(postModel.post.picture.count == 1) {
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
        collectionWidth = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if(postModel.post.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if (postModel.post.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
    }else if(postModel.post.picture.count > 3 && postModel.post.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
    }else if(postModel.post.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
    }
    
    self.collectionViewHeight.constant = collectionHeight;
    self.collectionViewWidth.constant = collectionWidth;
    
    //如果没有地址,隐藏按钮
    if(postModel.post.location.length == 0){
        self.addressBtn.hidden = YES;
    }else{
        self.addressBtn.hidden = NO;
        [self.addressBtn setTitle:postModel.post.location forState:UIControlStateNormal];
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
    if (postModel.post.title.length == 0) {
        self.titleLabel.hidden = YES;
        self.contentLabelTopConstrait.constant = 10;
        self.eliteImageV.hidden = YES;
    }else{
        //是否显示精华帖标志
        if ([postModel.post.elite integerValue] == 1) {//1是精华帖 2不是精华帖
            self.eliteImageV.hidden = NO;
            self.titleLabelRightConstait.constant = 37;
        }else{
            self.eliteImageV.hidden = YES;
            self.titleLabelRightConstait.constant = 10;
        }
        self.titleLabel.hidden = NO;
        self.contentLabelTopConstrait.constant = 35;
    }
    [self.collectionView reloadData];
}

- (void)setCommunity_Post:(GLCommunity_Detail_elite *)community_Post{
    _community_Post = community_Post;
    
//    if (community_Post.user_name.length == 0) {
//        self.nameLabel.text = community_Post.phone;
//    }else{
        self.nameLabel.text = community_Post.user_name;
//    }

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:community_Post.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.communityLabel.text = [formattime formateTimeOfDate:[NSString stringWithFormat:@"%@",community_Post.post.time]];
    
    self.titleLabel.text = community_Post.post.title;

    if (community_Post.post.topic.length == 0) {
        self.contentLabel.text = community_Post.post.content;
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"#%@# %@",community_Post.post.topic,community_Post.post.content];
    }
    
    [self.praiseBtn setImage:[UIImage imageNamed:@"浏览"] forState:UIControlStateNormal];
    if (community_Post.post.pv.length == 0) {
        [self.praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setTitle:community_Post.post.pv forState:UIControlStateNormal];
    }
    
    [self.commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    if (community_Post.post.comments.length == 0) {
        [self.commentBtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.commentBtn setTitle:community_Post.post.comments forState:UIControlStateNormal];
    }
    
    CGFloat collectionHeight = 0.0;
    CGFloat collectionWidth = 0.0;
    collectionWidth = kSCREEN_WIDTH;
    if(community_Post.post.picture.count == 0){
        collectionHeight = 0;
    }else if(community_Post.post.picture.count == 1) {
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
        collectionWidth = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if(community_Post.post.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if (community_Post.post.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
    }else if(community_Post.post.picture.count > 3 && community_Post.post.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
    }else if(community_Post.post.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
    }
    
    self.collectionViewHeight.constant = collectionHeight;
    self.collectionViewWidth.constant = collectionWidth;
    
    //如果没有地址,隐藏按钮
    if(community_Post.post.location.length == 0){
        self.addressBtn.hidden = YES;
    }else{
        self.addressBtn.hidden = NO;
        [self.addressBtn setTitle:community_Post.post.location forState:UIControlStateNormal];
    }
    
    //是否隐藏关注按钮
    if (community_Post.isHiddenAttendBtn) {
        self.attentionBtn.hidden = YES;
    }else{
        self.attentionBtn.hidden = NO;
    }
    
    //是否隐藏楼主标志
    if(community_Post.isHiddenLandlord){
        self.landlordBtn.hidden = YES;
    }else{
        self.landlordBtn.hidden = NO;
    }
    
    //是否隐藏标题label
    if (community_Post.post.title.length == 0) {
        self.titleLabel.hidden = YES;
        self.contentLabelTopConstrait.constant = 10;
        self.eliteImageV.hidden = YES;
    }else{
        //是否显示精华帖标志
        if ([community_Post.post.elite integerValue] == 1) {//1是精华帖 2不是精华帖
            self.eliteImageV.hidden = NO;
            self.titleLabelRightConstait.constant = 37;
        }else{
            self.eliteImageV.hidden = YES;
            self.titleLabelRightConstait.constant = 10;
        }
        self.titleLabel.hidden = NO;
        self.contentLabelTopConstrait.constant = 35;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - GLHomeAttentionCellDelegate
//评论
- (IBAction)comment:(id)sender {

    if ([self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.index];
    }
    if ([self.delegate respondsToSelector:@selector(postPraise:)]) {
        [self.delegate postPraise:self.index];
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

    if (self.model) {
        return self.model.post.picture.count;
    }else if(self.postModel){
        return self.postModel.post.picture.count;
    }else if(self.search_postModel){
        return self.search_postModel.post.picture.count;
    }else{
        return self.community_Post.post.picture.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_AttentionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHome_AttentionCollectionCell" forIndexPath:indexPath];

    NSString *imageName;
    NSString *img;
    
    if (self.model) {
        imageName = self.model.post.picture[indexPath.row];
    }else if(self.postModel){
        imageName = self.postModel.post.picture[indexPath.row];
    }else if(self.search_postModel){
        imageName = self.search_postModel.post.picture[indexPath.row];
    }else{
        imageName = self.community_Post.post.picture[indexPath.row];
    }
    img = [NSString stringWithFormat:@"%@?x-oss-process=style/miquan",imageName];//300X300
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(clickToBigImage:index:)]) {
        [self.delegate clickToBigImage:self.index index:indexPath.row];
    }
    
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return smallSpace;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return smallSpace;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.postModel){
        
        if (self.postModel.post.picture.count == 1) {
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }else if(self.postModel.post.picture.count == 2){
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }
        
        return CGSizeMake((kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3, (kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3);

    }else if(self.model){
        
        if (self.model.post.picture.count == 1) {
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }else if(self.model.post.picture.count == 2){
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }
        
        return CGSizeMake((kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3, (kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3);
    }else if(self.search_postModel){
        if (self.search_postModel.post.picture.count == 1) {
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }else if(self.search_postModel.post.picture.count == 2){
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }
        
        return CGSizeMake((kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3, (kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3);
    }else{
        if (self.community_Post.post.picture.count == 1) {
            
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }else if(self.community_Post.post.picture.count == 2){
            return CGSizeMake((kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2, (kSCREEN_WIDTH - 2 * bigSpace - smallSpace)/2);
        }
        
        return CGSizeMake((kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3, (kSCREEN_WIDTH - 2*(bigSpace + smallSpace))/3);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(smallSpace, bigSpace, smallSpace, bigSpace);
}

@end
