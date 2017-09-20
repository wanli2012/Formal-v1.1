//
//  GLCommunity_PostMainCommentModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/19.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface replyModel : NSObject
//
//@property (nonatomic, copy)NSString *reply_id;
//@property (nonatomic, copy)NSString *content;
//@property (nonatomic, copy)NSString *mid;
//@property (nonatomic, copy)NSString *user_name;
//@property (nonatomic, copy)NSString *group_id;
//@property (nonatomic, copy)NSString *mcid;
//@property (nonatomic, copy)NSString *nickname;
//@property (nonatomic, copy)NSString *identity;
//
//@end

@interface GLCommunity_PostMainCommentModel : NSObject

@property (nonatomic, copy)NSString *comm_id;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *commenttiem;
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *reply_laud;
@property (nonatomic, copy)NSString *reply_publish;
@property (nonatomic, copy)NSArray *reply;

@property (nonatomic, assign)CGFloat cellHeight;//cell总高度


@end
