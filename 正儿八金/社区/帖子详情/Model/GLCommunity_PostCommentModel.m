//
//  GLCommunity_PostCommentModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostCommentModel.h"

@implementation replyModel

@end

@implementation postModel

@end

@implementation mainModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"reply":@"replyModel"};
}

- (CGFloat)cellHeight{
    
    //主评论的高度
    CGSize titleSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    //子评论的高度
    CGFloat height = 0.0;
    
    for (replyModel *reply in self.reply) {
            
        NSString *str = [NSString stringWithFormat:@"%@:%@",reply.user_name,reply.content];
        
        CGSize commentSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        height = height + commentSize.height + 5;
        
    }
    
    if ([self.reply_publish integerValue] > 2) {
        
        NSString *str = [NSString stringWithFormat:@"查看所有%@条回复>>",self.reply_publish];
        CGSize commentSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        height = height + commentSize.height + 5;
    }

    return 70 + titleSize.height + height;

}
@end

@implementation GLCommunity_PostCommentModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"reply":@"replyModel",
             @"main":@"mainModel"};
}

- (CGFloat)cellHeight{
    
//    CGSize titleSize = [self.post.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
//
//    CGFloat collectionHeight = 0.0;
//    if(self.post.picture.count == 0){
//        collectionHeight = 0;
//    }else if(self.post.picture.count == 1) {
//        //        collectionHeight = kSCREEN_WIDTH - 30;
//        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
//    }else if(self.post.picture.count == 2){
//        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
//    }else if (self.post.picture.count== 3){
//        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
//    }else if(self.post.picture.count > 3 && self.post.picture.count <= 6){
//        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
//    }else if(self.post.picture.count > 6){
//        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
//    }
//
//    
//    return 140 + titleSize.height + collectionHeight;
    
    
    
    CGSize contentSize = [self.post.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGFloat collectionHeight = 0.0;
    if(self.post.picture.count == 0){
        collectionHeight = 0;
    }else if(self.post.picture.count == 1) {
        //        collectionHeight = kSCREEN_WIDTH - 30;
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if(self.post.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if (self.post.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
    }else if(self.post.picture.count > 3 && self.post.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
    }else if(self.post.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
    }
    
    if(self.post.title.length == 0){//没有title
        if (self.post.picture.count == 0) {//也没有图片,在contentLabel底部有10的间距
            
            return 115 + contentSize.height + collectionHeight;
            
        }else{//有图片,在contentLabel底部去掉10的间距 间距在collectinView里面设置
            
            return 105 + contentSize.height + collectionHeight;
        }
    }
    
    return 105 + 25 + contentSize.height + collectionHeight;

}

@end
