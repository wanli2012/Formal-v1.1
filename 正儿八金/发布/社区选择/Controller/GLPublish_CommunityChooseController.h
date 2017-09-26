//
//  GLPublish_CommunityChooseController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GLPublish_CommunityChooseController : UIViewController

typedef void(^communityChoose)(NSString *communityName,NSString *bar_id);
/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) communityChoose block;

@end
