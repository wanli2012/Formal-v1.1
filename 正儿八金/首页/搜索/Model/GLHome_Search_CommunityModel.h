//
//  GLHome_Search_CommunityModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_Search_CommunityModel : NSObject

@property (nonatomic, copy)NSString *name;//社区名
@property (nonatomic, copy)NSString *picture;//社区图片
@property (nonatomic, copy)NSString *post_num;//该社区下帖子总数
@property (nonatomic, copy)NSString *comm_num;//社区评论数
@property (nonatomic, copy)NSString *bar_id;//社区Id
@property (nonatomic, copy)NSString *follow;//是否关注社区 1 关注 2未关注 uid空默认2

@property (nonatomic, assign)BOOL isHiddenAttendLabel;//是否隐藏关注人数label

@end
