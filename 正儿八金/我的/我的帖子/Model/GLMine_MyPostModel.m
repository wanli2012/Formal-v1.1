//
//  GLMine_MyPostModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostModel.h"

@implementation GLMine_MyPost

- (CGFloat)cellHeight{
    
//    CGSize titleSize = [self.title boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGSize contentSize;
    if (self.title.length == 0) {
        
        if([self.elite integerValue] == 1){
            contentSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }else{
            contentSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }
    }else{
        if ([self.elite integerValue] == 1) {//是精华帖
            
            contentSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 45, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }else{//不是精华帖
            
            contentSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }
    }
    
    CGFloat collectionHeight = 0.0;
    
    if(self.picture.count == 0){
        collectionHeight = 0;
    }else if (self.picture.count == 1) {
        collectionHeight = (kSCREEN_WIDTH - 25)/2 + 20;
    }else if(self.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 25)/2 + 20;
    }else if (self.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 30)/3 + 20;
        
    }else if(self.picture.count > 3 && self.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 30)/3 + 25;
    }else if(self.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 30)/3 + 30;
    }
    
    if (self.title.length == 0) {
        if(contentSize.height <= 20){
            return 65 + collectionHeight;
        }else{
            return 65 + collectionHeight + contentSize.height - 20;
        }
    }else{
        return 75 + collectionHeight + contentSize.height;
    }
    
}

@end


@implementation GLMine_MyPostModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"post":@"GLMine_MyPost"};
}
@end
