//
//  GLCommunity_PostController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLCommunity_PostControllerBlock)(NSString *praiseNum,NSString *fabulous);

@interface GLCommunity_PostController : UIViewController

@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *post_id;
@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, copy)GLCommunity_PostControllerBlock block;

@end
