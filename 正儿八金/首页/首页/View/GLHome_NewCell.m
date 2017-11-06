//
//  GLHome_NewCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_NewCell.h"

@implementation GLHome_NewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
    
    self.contentView.layer.cornerRadius = 3;
    
    self.contentView.layer.borderWidth = 1;
    
    self.contentView.layer.borderColor = YYSRGBColor(0, 0, 0, 0.08).CGColor;
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.layer.shadowColor = YYSRGBColor(0, 0, 0, 1).CGColor;
    
    self.layer.shadowOpacity = 0.1;
    
    self.layer.shadowRadius = 4;
    
    self.layer.masksToBounds = NO;
    
}

@end
