//
//  GLPublish_CommunityModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLPublish_CommunityModel : NSObject

@property (nonatomic, copy)NSString *bar_id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *picture;


@property (nonatomic, copy)NSString *topic;//话题   GLPublish_TopicCell用的,因为只有一个字段就用的这个模型了

@end
