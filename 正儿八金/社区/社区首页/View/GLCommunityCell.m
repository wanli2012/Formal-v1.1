//
//  GLCommunityCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunityCell.h"

@interface GLCommunityCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentLabel;//关注人数


@end

@implementation GLCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.attentBtn.layer.cornerRadius = 5.f;
    self.attentBtn.layer.borderWidth = 1.f;
    self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.attentBtn.backgroundColor = MAIN_COLOR;
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}

- (IBAction)attentClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(attent:)]) {
        [self.delegate attent:self.index];
    }
    
}
- (void)setModel:(GLCommunity_FollowModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.name;
    self.detailLabel.text = model.mark;
    self.attentLabel.text = [NSString stringWithFormat:@"关注:%@",model.num];
    
    if (model.isHiddenAttendBtn) {
        self.attentBtn.hidden = YES;
    }else{
        self.attentBtn.hidden = NO;
    }
}

- (void)setRecommendModel:(GLCommunity_RecommendModel *)recommendModel{
    
    _recommendModel = recommendModel;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:recommendModel.picture] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = recommendModel.name;
    self.detailLabel.text = [NSString stringWithFormat:@"帖子:%@ 评论:%@",recommendModel.post_num,recommendModel.comm_num];
    
    if (recommendModel.isHiddenAttendLabel) {
        self.attentLabel.hidden = YES;
    }else{
        self.attentLabel.hidden = NO;
    }
    
    if(recommendModel.isAttention){
        self.attentBtn.backgroundColor = [UIColor whiteColor];
        [self.attentBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [self.attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.attentBtn.enabled = NO;
        
    }else{
        self.attentBtn.backgroundColor = MAIN_COLOR;
        [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.attentBtn.enabled = YES;
    }
}


@end
