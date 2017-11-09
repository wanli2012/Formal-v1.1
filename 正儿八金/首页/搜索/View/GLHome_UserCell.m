//
//  GLHome_UserCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_UserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLHome_UserCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GLHome_UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.layer.cornerRadius = self.imageV.height / 2;
    self.attentionBtn.layer.cornerRadius = 5.f;
}

- (IBAction)click:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(attent:)]){
        [self.delegate attent:self.index];
    }
}

- (void)setModel:(GLHome_Search_UserModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.user_name;
    self.detailLabel.text = [NSString stringWithFormat:@"粉丝:%@",model.fans];
    
    self.attentionBtn.enabled = NO;
    if ([model.follow integerValue] == 1) {//是否关注用户 1 关注 2未关注 uid空默认2
        
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.attentionBtn.backgroundColor = [UIColor whiteColor];
        self.attentionBtn.layer.borderColor = MAIN_COLOR.CGColor;
        self.attentionBtn.layer.borderWidth = 1.f;

    }else{
        
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.attentionBtn.backgroundColor = [UIColor whiteColor];
        self.attentionBtn.layer.borderColor = MAIN_COLOR.CGColor;
        self.attentionBtn.layer.borderWidth = 1.f;
    }
}
@end
