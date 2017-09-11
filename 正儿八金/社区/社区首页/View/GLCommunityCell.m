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

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation GLCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.attentBtn.layer.cornerRadius = 5.f;
    self.attentBtn.layer.borderWidth = 1.f;
    self.attentBtn.layer.borderColor = MAIN_COLOR.CGColor;
    
}

- (IBAction)attentClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(attent:)]) {
        [self.delegate attent:self.index];
    }
    
}



@end
