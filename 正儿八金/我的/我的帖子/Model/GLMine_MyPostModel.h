//
//  GLMine_MyPostModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_MyPost : NSObject

@property (nonatomic, copy)NSString *location;//发帖的位置
@property (nonatomic, copy)NSArray *picture;//帖子图片
@property (nonatomic, copy)NSString *post_id;//帖子id
@property (nonatomic, copy)NSString *pv;//帖子浏览量
@property (nonatomic, copy)NSString *quantity;//帖子评论量
@property (nonatomic, copy)NSString *time;//发帖时间
@property (nonatomic, copy)NSString *title;//帖子标题
@property (nonatomic, copy)NSString *content;//发帖内容
@property (nonatomic, copy)NSString *fabulous;//评论是否点赞 1点赞 2未点赞 uid等于空默认未点赞

@property (nonatomic, assign)CGFloat cellHeight;

@end

@interface GLMine_MyPostModel : NSObject

@property (nonatomic, copy)NSString *fans;//被查看用户的粉丝
@property (nonatomic, copy)NSString *follow;//被查看用户关注的人数
@property (nonatomic, copy)NSString *icon;//被查看用户等级图标
@property (nonatomic, copy)NSString *number_name;//被查看用户等级
@property (nonatomic, copy)NSString *portrait;//被查看用户头像
@property (nonatomic, copy)NSArray <GLMine_MyPost *>*post;//获取被查看用户的帖子，数组格式没数据默认null
@property (nonatomic, copy)NSString *posts;//被查看用户的总数量帖子
@property (nonatomic, copy)NSString *status;//查看人是否关注被查看人 1关注 2未关注 未登录查看默认2
@property (nonatomic, copy)NSString *user_id;//被查看用户id
@property (nonatomic, copy)NSString *user_name;//被查看用户昵称

@end


