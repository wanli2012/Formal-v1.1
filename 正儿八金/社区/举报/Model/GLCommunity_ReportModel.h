//
//  GLCommunity_ReportModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/2.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCommunity_rtypeModel : NSObject

@property (nonatomic, copy)NSString *type_id;
@property (nonatomic, copy)NSString *type_name;

@property (nonatomic, assign)BOOL isSelected;//是否选中了

@end

@interface GLCommunity_ReportModel : NSObject

@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, copy)NSArray<GLCommunity_rtypeModel *>* rtype;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *user_name;


@end
