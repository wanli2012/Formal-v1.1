//
//  GLMine_EventCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EventCell.h"

@interface GLMine_EventCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation GLMine_EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.bgImageV.layer.shadowOpacity = 0.5f;
    self.bgImageV.layer.shadowOffset = CGSizeMake(0.f, 3.0f);
    self.bgImageV.layer.shadowRadius = 5.0f;

    self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.bgView.layer.shadowRadius = 5.0f;


    self.bgView.layer.cornerRadius = 5.f;
    self.bgImageV.layer.cornerRadius = 5.f;
    
    self.bgImageV.layer.masksToBounds = YES;
}


@end
