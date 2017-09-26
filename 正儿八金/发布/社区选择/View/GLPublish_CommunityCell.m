//
//  GLPublish_CommunityCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_CommunityCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLPublish_CommunityCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GLPublish_CommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLPublish_CommunityModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
}

@end
