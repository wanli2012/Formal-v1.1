//
//  GLCommunity_FollowController.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLCommunity_FollowDelegate <NSObject>

- (void)pushControllerWithIndex:(NSInteger)index;

@end

@interface GLCommunity_FollowController : UITableViewController

@property (nonatomic, strong)NSArray *dataSource;

@property (nonatomic, weak)id <GLCommunity_FollowDelegate> delegate;

@end
