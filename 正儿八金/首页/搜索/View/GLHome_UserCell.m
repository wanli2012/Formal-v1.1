//
//  GLHome_UserCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_UserCell.h"

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

@end
