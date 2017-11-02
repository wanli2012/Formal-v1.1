//
//  GLCommunity_ReportCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/2.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_ReportCell.h"

@interface GLCommunity_ReportCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GLCommunity_ReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
    
    
}
- (void)setModel:(GLCommunity_rtypeModel *)model{
    _model = model;
    
    self.titleLabel.text = model.type_name;
    
    if (model.isSelected) {
        self.selectImageV.backgroundColor = [UIColor blackColor];
    }else{
        self.selectImageV.backgroundColor = [UIColor redColor];
    }
    
}

- (void)click{
    
    if ([self.delegate respondsToSelector:@selector(selectReason:)]) {
        [self.delegate selectReason:self.index];
    }
}


@end
