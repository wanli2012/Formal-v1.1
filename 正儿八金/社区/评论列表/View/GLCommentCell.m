//
//  GLCommentCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;

@end

@implementation GLCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(commentModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = model.user_name;
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    self.contentLabel.text = model.content;
    [self.priseBtn setTitle:model.laud forState:UIControlStateNormal];
    
}

@end
