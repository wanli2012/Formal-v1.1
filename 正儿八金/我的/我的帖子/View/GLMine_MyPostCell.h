//
//  GLMine_MyPostCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_MyPostModel.h"

@protocol GLMine_MyPostCellDelegate <NSObject>

- (void)clickToBigImage:(NSInteger)cellIndex index:(NSInteger)index;

@optional
- (void)deleteThePost:(NSInteger)cellIndex;
@end

@interface GLMine_MyPostCell : UITableViewCell

@property (nonatomic, strong)GLMine_MyPost *model;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLMine_MyPostCellDelegate> delegate;

@end
