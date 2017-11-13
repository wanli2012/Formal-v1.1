//
//  GLPublish_TopicChooseController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^topicChoose)(NSString *topic);

@interface GLPublish_TopicChooseController : UIViewController

/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) topicChoose block;

@end
