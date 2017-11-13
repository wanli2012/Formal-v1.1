//
//  GLCommunity_DetailModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_DetailModel.h"

@implementation GLCommunity_Detail_post

@end

@implementation GLCommunity_Detail_elite

- (CGFloat)cellHeight{
    
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

@implementation GLCommunity_Detail_users

@end

@implementation GLCommunity_Detail_Toppost

@end

@implementation GLCommunity_DetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"postdata":@"GLCommunity_Detail_elite",
             @"elite":@"GLCommunity_Detail_elite",
             @"users":@"GLCommunity_Detail_users"};
}

@end
