//
//  GLCommunity_PostCommentModel.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCommunity_PostCommentModel : NSObject

@property (nonatomic, copy)NSString *comment;//评论

@property (nonatomic, copy)NSString *son_commentName;//自评论人

@property (nonatomic, copy)NSString *son_comment;//子评论

@property (nonatomic, copy)NSArray *commentArr;//子评论数组

@property (nonatomic, assign)CGFloat cellHeight;//cell总高度

@end
