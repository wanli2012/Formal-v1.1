//
//  GLMine_MyPostModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyPostModel.h"

@implementation GLMine_MyPostModel

- (CGFloat)cellHeight{
    CGSize titleSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGFloat collectionHeight;
    
    if(self.picture.count == 0){
        collectionHeight = 0;
    }else if (self.picture.count == 1) {
        collectionHeight = kSCREEN_WIDTH - 20;
    }else if(self.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 35)/2 + 10;
    }else if (self.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3 + 10;
        
    }else if(self.picture.count > 3 && self.picture.count <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 15;
    }else if(self.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 30;
    }
    
    return 65 + titleSize.height + collectionHeight;
}

@end
