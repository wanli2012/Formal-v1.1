//
//  GLCommunity_FollowModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/1.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCommunity_FollowModel : NSObject

@property (nonatomic, copy)NSString *id;//社区Id
@property (nonatomic, copy)NSString *name;//社区名
@property (nonatomic, copy)NSString *picture;//社区图片
@property (nonatomic, copy)NSString *mark;//社区介绍
@property (nonatomic, copy)NSString *num;//社区关注人数

@property (nonatomic, assign)BOOL isHiddenAttendBtn;//是否隐藏关注人数Btn

@end


@interface GLCommunity_RecommendModel : NSObject

@property (nonatomic, copy)NSString *id;//社区Id
@property (nonatomic, copy)NSString *name;//社区名
@property (nonatomic, copy)NSString *picture;//社区图片
@property (nonatomic, copy)NSString *post_num;//该社区下帖子总数
@property (nonatomic, copy)NSString *comm_num;//社区评论数

@property (nonatomic, assign)BOOL isAttention;//是否已关注
@property (nonatomic, assign)BOOL isHiddenAttendLabel;//是否隐藏关注人数label

//搜索多出来的字段(两个)
@property (nonatomic, copy)NSString *bar_id;//社区Id
@property (nonatomic, copy)NSString *follow;//是否关注社区 1 关注 2未关注 uid空默认2

@end
