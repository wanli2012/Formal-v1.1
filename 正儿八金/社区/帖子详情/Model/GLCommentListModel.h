//
//  GLCommentListModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject

@property (nonatomic, copy)NSString *addtime;//评论时间
@property (nonatomic, copy)NSString *content;//评论内容
@property (nonatomic, copy)NSString *group_id;//评论用户身份类型
@property (nonatomic, copy)NSString *identity;//被评论人身份类型 直接评论一级评论为 null
@property (nonatomic, copy)NSString *laud;//评论点赞量
@property (nonatomic, copy)NSString *mcid;//被评论人 uid 直接评论一级评论为 null
@property (nonatomic, copy)NSString *mid;//评论用户uid
@property (nonatomic, copy)NSString *nickname;//被评论人昵称 直接评论一级评论为 null
@property (nonatomic, copy)NSString *pic;//评论用户头像
@property (nonatomic, copy)NSString *reply_id;//评论ID
@property (nonatomic, copy)NSString *user_name;//评论用户昵称

@end

@interface GLCommentListModel : NSObject

@property (nonatomic, copy)NSString *comm_id;//评论id
@property (nonatomic, copy)NSString *commenttiem;//评论时间
@property (nonatomic, copy)NSString *content;//评论内容
@property (nonatomic, copy)NSString *group_id;//评论用户的身份类型
@property (nonatomic, copy)NSString *mid;//评论的用户id
@property (nonatomic, copy)NSString *portrait;//评论用户的头像
@property (nonatomic, copy)NSString *reply_laud;//评论的点赞量
@property (nonatomic, copy)NSString *reply_publish;//评论的评论量
@property (nonatomic, copy)NSString *user_name;//评论用户的昵称
@property (nonatomic, copy)NSArray *post;//评论的下级评论数据数组

@end
