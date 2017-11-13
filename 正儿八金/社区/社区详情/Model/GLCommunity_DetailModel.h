//
//  GLCommunity_DetailModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCommunity_Detail_post : NSObject

@property (nonatomic, copy)NSString *topic;//帖子话题
@property (nonatomic, copy)NSString *post_id;//帖子id
@property (nonatomic, copy)NSString *location;//帖子发布位置
@property (nonatomic, copy)NSString *postbar_id;//社区id
@property (nonatomic, copy)NSString *title;//帖子标题
@property (nonatomic, copy)NSString *content;//帖子内容
@property (nonatomic, copy)NSString *pv;//帖子浏览量
@property (nonatomic, copy)NSArray *picture;//图片
@property (nonatomic, copy)NSString *time;//发帖时间
@property (nonatomic, copy)NSString *comments;//帖子评论数
@property (nonatomic, copy)NSString *elite;//是否为精华帖 1:精华帖 2:正常

@end

@interface GLCommunity_Detail_elite : NSObject

@property (nonatomic, copy)NSString *mid;//活跃用户id
@property (nonatomic, copy)NSString *user_name;//活跃用户名
@property (nonatomic, copy)NSString *portrait;//活跃用户头像
@property (nonatomic, copy)NSString *group_id;//活跃用户头像
@property (nonatomic, strong)GLCommunity_Detail_post *post;//活跃用户头像

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)BOOL isHiddenAttendBtn;//关注按钮是否隐藏
@property (nonatomic, assign)BOOL isHiddenLandlord;//楼主标志是否隐藏
@property (nonatomic, assign)BOOL isHiddenTitleLabel;//标题是否隐藏

@end

@interface GLCommunity_Detail_users : NSObject

@property (nonatomic, copy)NSString *uid;//活跃用户id
@property (nonatomic, copy)NSString *user_name;//活跃用户名
@property (nonatomic, copy)NSString *header_pic;//活跃用户头像

@end

@interface GLCommunity_Detail_Toppost : NSObject

@property (nonatomic, copy)NSString *content;//置顶帖子内容
@property (nonatomic, copy)NSString *group_id;//用户分组id
@property (nonatomic, copy)NSString *post_id;//社区置顶帖子id
@property (nonatomic, copy)NSString *title;//置顶帖子标题
@property (nonatomic, copy)NSString *uid;//用户id

@end

@interface GLCommunity_DetailModel : NSObject

@property (nonatomic, copy)NSString *postbarname;//社区名
@property (nonatomic, copy)NSString *postbar_pic;//社区头像
@property (nonatomic, copy)NSString *carenum;//关注总数
@property (nonatomic, copy)NSString *totalnum;//主贴总数
@property (nonatomic, copy)NSString *userstatus;//用户关注1:已关注 2:未关注
@property (nonatomic, strong)GLCommunity_Detail_Toppost *toppost;//置顶帖
@property (nonatomic, copy)NSArray <GLCommunity_Detail_elite *>*postdata;//所有帖子
@property (nonatomic, copy)NSArray <GLCommunity_Detail_elite *>*elite;//精华帖
@property (nonatomic, copy)NSArray <GLCommunity_Detail_users *>*users;//活跃用户

@end
