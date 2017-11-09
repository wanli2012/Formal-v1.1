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
