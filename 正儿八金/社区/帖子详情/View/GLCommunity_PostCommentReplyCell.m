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

//    NSString *content = model.content;
//    
//    NSString *str = [NSString stringWithFormat:@"%@",model.nickname];
//    typeof(self)weakSelf = self;
//    if (model.user_name == nil && model.nickname == nil) {
//        
//        self.contentLabel.text = content;
//        self.contentLabel.selectBlobk = nil;
//        
//    }else if ([str rangeOfString:@"null"].location != NSNotFound) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@:%@",model.user_name,model.content];
//        
//        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSRange redRange = NSMakeRange(0, model.user_name.length);
//        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
//        
//        self.contentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.user_name.length))];
//        
//        self.contentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
//            
//            if ([weakSelf.delegate respondsToSelector:@selector(personInfo:isSecondComment:)]) {
//                [weakSelf.delegate personInfo:weakSelf.index isSecondComment:YES];
//            }
//        };
//        
//        self.contentLabel.attributedText = noteStr;
//        
//    }else{
//        
//        NSString *str = [NSString stringWithFormat:@"%@回复%@: %@",model.user_name,model.nickname,model.content];
//        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSRange redRange = NSMakeRange(0, model.user_name.length);
//        NSRange redRange2 = NSMakeRange(model.user_name.length + 2, model.nickname.length);
//        
//        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
//        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange2];
//        
//        self.contentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.user_name.length)),NSStringFromRange(NSMakeRange(model.user_name.length + 2, model.nickname.length))];
//        
//        
//        self.contentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
//
//            if ([self.delegate respondsToSelector:@selector(personInfo:isSecondComment:)]) {
//                
//                if (index == 0) {
//                    [weakSelf.delegate personInfo:weakSelf.index isSecondComment:YES];
//                    //                weakSelf.block(weakSelf.cellIndex,weakSelf.index,YES);
//                }else{
//                    [weakSelf.delegate personInfo:weakSelf.index isSecondComment:NO];
////                    weakSelf.block(weakSelf.cellIndex,weakSelf.index,NO);
//                }
//            }
//
//            NSLog(@"str = %@",str);
//            
//        };
//        
//        self.contentLabel.attributedText = noteStr;
//        
//    }

//    [self.contentLabel sizeToFit];

}

@end
