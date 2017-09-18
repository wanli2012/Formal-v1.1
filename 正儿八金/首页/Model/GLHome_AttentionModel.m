//
//  GLHome_AttentionModel.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_AttentionModel.h"

@implementation GLHome_AttentionModel

- (CGFloat)cellHeight{
    CGSize titleSize = [self.content boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGFloat collectionHeight;
    
    if (self.post.picture.count == 1) {
        collectionHeight = kSCREEN_WIDTH - 20;
    }else if(self.post.picture.count == 2){
        collectionHeight = (kSCREEN_WIDTH - 30)/2;
    }else if (self.post.picture.count== 3){
        collectionHeight = (kSCREEN_WIDTH - 40)/3;
    }else if(self.post.picture.count > 3 && [self.sum integerValue] <= 6){
        collectionHeight = 2 *(kSCREEN_WIDTH - 40)/3 + 10;
    }else if(self.post.picture.count > 6){
        collectionHeight = 3 *(kSCREEN_WIDTH - 40)/3 + 20;
    }
    
    return 140 + titleSize.height + collectionHeight;
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    if([key isEqualToString:@"id"]){
//        self.userId = value;
//    }
//}

@end
