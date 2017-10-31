//
//  GLHome_AttentionModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLHome_AttentionPostModel.h"

@interface GLHome_AttentionModel : NSObject

//@property (nonatomic, strong)NSString *content;

//@property (nonatomic, assign)NSString *sum;

@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, assign)BOOL isHiddenAttendBtn;//关注按钮是否隐藏

@property (nonatomic, assign)BOOL isHiddenLandlord;//楼主标志是否隐藏

@property (nonatomic, assign)BOOL isHiddenTitleLabel;//标题是否隐藏

@property (nonatomic, strong)NSString *mid;
@property (nonatomic, strong)NSString *group_id;
@property (nonatomic, strong)NSString *portrait;
@property (nonatomic, strong)GLHome_AttentionPostModel *post;
@property (nonatomic, strong)NSString *status;//关注状态 1:已关注  2:未关注

@property (nonatomic, strong)NSString *user_name;

@end



