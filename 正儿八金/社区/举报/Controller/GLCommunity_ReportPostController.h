//
//  GLCommunity_ReportPostController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/2.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLCommunity_ReportPostController : UIViewController

@property (nonatomic, copy)NSString *imageUrl;//头像 url
@property (nonatomic, copy)NSString *name;//被举报人
@property (nonatomic, copy)NSString *postTitle;//帖子标题
@property (nonatomic, copy)NSString *mid;//被举报人id
@property (nonatomic, copy)NSString *group_id;//被举报人身份类型
@property (nonatomic, copy)NSString *post_id;//被举报帖子id


@end
