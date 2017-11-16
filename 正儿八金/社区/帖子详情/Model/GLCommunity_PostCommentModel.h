//
//  GLCommunity_PostCommentModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface replyModel : NSObject

@property (nonatomic, copy)NSString *reply_id;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *mcid;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *identity;

@end

@interface mainModel : NSObject

@property (nonatomic, copy)NSString *comm_id;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *commenttiem;
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *reply_laud;
@property (nonatomic, copy)NSString *reply_publish;
@property (nonatomic, copy)NSArray <replyModel *>*reply;
@property (nonatomic, copy)NSString *ctfabulous;

@property (nonatomic, assign)CGFloat cellHeight;//cell总高度

@end

@interface postModel : NSObject

@property (nonatomic, copy)NSString *post_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *paste_name;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, copy)NSArray *picture;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *pv;
@property (nonatomic, copy)NSString *praise;
@property (nonatomic, copy)NSString *fabulous;
@property (nonatomic, strong)NSString *elite;//1是精华帖 2不是精华帖
@property (nonatomic, strong)NSString *topic;//话题

@property (nonatomic, assign)CGFloat cellHeight;//cell总高度

@end

@interface GLCommunity_PostCommentModel : NSObject

@property (nonatomic, copy)NSString *comment;//评论

@property (nonatomic, copy)NSString *son_commentName;//自评论人

@property (nonatomic, copy)NSString *son_comment;//子评论

@property (nonatomic, copy)NSArray *commentArr;//子评论数组

@property (nonatomic, assign)BOOL isHiddenAttendBtn;//关注按钮是否隐藏

@property (nonatomic, assign)BOOL isHiddenLandlord;//楼主标志是否隐藏

@property (nonatomic, assign)BOOL isHiddenTitleLabel;//标题是否隐藏

@property (nonatomic, assign)CGFloat cellHeight;//cell总高度

@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *portrait;

@property (nonatomic, copy)NSString *starttime;//社区禁言用户开始时间 没有为空
@property (nonatomic, copy)NSString *endtime;//社区禁言用户结束时间 没有为空
@property (nonatomic, copy)NSString *scause;//禁言原因 没有为空

@property (nonatomic, strong)postModel *post;
@property (nonatomic, strong)NSArray <mainModel *> *main;

@end





