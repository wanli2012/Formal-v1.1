//
//  GLCommunity_PostCommentReplyCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostCommentReplyCell.h"


@interface GLCommunity_PostCommentReplyCell()


@end

@implementation GLCommunity_PostCommentReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
   
}
- (void)setModel:(replyModel *)model{
    _model = model;
    NSString *name = model.user_name;
    NSString *str = [NSString stringWithFormat:@"%@:%@",name,model.content];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
    
    [self.contentLabel setAttributedText:noteStr] ;
    [self.contentLabel sizeToFit];

    
}

@end
