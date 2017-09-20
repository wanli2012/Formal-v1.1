//
//  GLCommunity_PostMainCommentModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/19.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostMainCommentModel.h"


//@implementation replyModel
//
//@end

@implementation GLCommunity_PostMainCommentModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"reply":@"replyModel"};
}


-(CGFloat)cellHeight{
        //主评论的高度
        CGSize titleSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    //    //子评论的高度
        CGFloat height = 0.0;
    
//    for (replyModel *model in self.reply) {
//        
//            NSString *str = [NSString stringWithFormat:@"%@:%@",model.user_name,model.content];
//    
//            CGSize commentSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
//    
//            height = height + commentSize.height + 5;
//        }
    
        return 70 + titleSize.height + height;
}


@end
