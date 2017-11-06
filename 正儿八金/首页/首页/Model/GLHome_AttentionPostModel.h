//
//  GLHome_AttentionPostModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_AttentionPostModel : NSObject

@property (nonatomic, strong)NSString *title;//帖子标题
@property (nonatomic, strong)NSString *content;//发帖内容
@property (nonatomic, strong)NSArray *picture;//帖子图片 有图片数组格式
@property (nonatomic, strong)NSString *post_id;//帖子id
@property (nonatomic, strong)NSString *praise;//帖子点赞量
@property (nonatomic, strong)NSString *quantity;//帖子评论量
@property (nonatomic, strong)NSString *time;//发帖时间
@property (nonatomic, strong)NSString *location;//发帖地址
@property (nonatomic, strong)NSString *fabulous;//点赞状态 1:已点赞  2:未点赞
@property (nonatomic, strong)NSString *elite;//1是精华帖 2不是精华帖

@end
