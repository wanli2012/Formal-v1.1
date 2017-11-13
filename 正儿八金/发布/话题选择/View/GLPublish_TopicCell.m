//
//  GLPublish_TopicCellCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_TopicCell.h"


@interface GLPublish_TopicCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GLPublish_TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setModel:(GLPublish_CommunityModel *)model{
    _model = model;
    self.titleLabel.text = model.topic;
}

@end
