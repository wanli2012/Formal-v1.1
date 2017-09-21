//
//  GLCommentListController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLCommentListBlock)(NSString *praiseNum,NSString *fabulous);

@interface GLCommentListController : UIViewController

@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *post_id;
@property (nonatomic, copy)NSString *comm_id;
@property (nonatomic, copy)GLCommentListBlock block;

@end
