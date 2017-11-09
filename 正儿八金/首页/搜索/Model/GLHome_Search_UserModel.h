//
//  GLHome_Search_UserModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_Search_UserModel : NSObject

@property (nonatomic, copy)NSString *mid;//用户id
@property (nonatomic, copy)NSString *group_id;//用户身份类型
@property (nonatomic, copy)NSString *user_name;//用户昵称
@property (nonatomic, copy)NSString *portrait;//用户头像
@property (nonatomic, copy)NSString *fans;//用户粉丝
@property (nonatomic, copy)NSString *follow;//是否关注用户 1 关注 2未关注 uid空默认2

@end
