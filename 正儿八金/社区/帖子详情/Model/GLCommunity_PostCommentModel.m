//
//  GLCommunity_PostCommentModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostCommentModel.h"

@implementation GLCommunity_PostCommentModel

- (CGFloat)cellHeight{
    
    //主评论的高度
    CGSize titleSize = [self.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    //子评论的高度
    CGFloat height = 0.0;
    for (int i = 0; i< self.commentArr.count; i ++) {
        GLCommunity_PostCommentModel *model = self.commentArr[i];
        
        NSString *str = [NSString stringWithFormat:@"%@:%@",model.son_commentName,model.son_comment];
        CGSize commentSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        height = height + commentSize.height + 5;
    }
    
    return 70 + titleSize.height + height;
    
}

@end
