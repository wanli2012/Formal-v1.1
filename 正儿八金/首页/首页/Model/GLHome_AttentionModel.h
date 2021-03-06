//
//  GLHome_AttentionModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_AttentionPostModel : NSObject

@property (nonatomic, strong)NSString *title;//帖子标题
@property (nonatomic, strong)NSString *content;//发帖内容
@property (nonatomic, strong)NSArray *picture;//帖子图片 有图片数组格式
@property (nonatomic, strong)NSString *post_id;//帖子id
@property (nonatomic, strong)NSString *praise;//帖子点赞量
@property (nonatomic, strong)NSString *time;//发帖时间
@property (nonatomic, strong)NSString *location;//发帖地址
@property (nonatomic, strong)NSString *fabulous;//点赞状态 1:已点赞  2:未点赞
@property (nonatomic, strong)NSString *elite;//1是精华帖 2不是精华帖

@property (nonatomic, strong)NSString *quantity;//帖子评论量
@property (nonatomic, strong)NSString *topic;//帖子话题

@end

@interface GLHome_AttentionModel : NSObject

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)BOOL isHiddenAttendBtn;//关注按钮是否隐藏
@property (nonatomic, assign)BOOL isHiddenLandlord;//楼主标志是否隐藏
//@property (nonatomic, assign)BOOL isHiddenTitleLabel;//标题是否隐藏
@property (nonatomic, strong)NSString *mid;
@property (nonatomic, strong)NSString *group_id;
@property (nonatomic, strong)NSString *portrait;
@property (nonatomic, strong)GLHome_AttentionPostModel *post;
@property (nonatomic, strong)NSString *user_name;

@property (nonatomic, strong)NSString *status;//关注状态 1:已关注  2:未关注
//@property (nonatomic, strong)NSString *follow;//是否关注用户 1 关注 2未关注 uid空默认2
@property (nonatomic, strong)NSString *phone;

@end
