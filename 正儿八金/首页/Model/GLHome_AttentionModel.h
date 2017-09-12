//
//  GLHome_AttentionModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_AttentionModel : NSObject

@property (nonatomic, strong)NSString *content;

@property (nonatomic, assign)NSString *sum;

@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, assign)BOOL isHiddenAttendBtn;//关注按钮是否隐藏

@property (nonatomic, assign)BOOL isHiddenLandlord;//楼主标志是否隐藏

@property (nonatomic, assign)BOOL isHiddenTitleLabel;//标题是否隐藏

@end
