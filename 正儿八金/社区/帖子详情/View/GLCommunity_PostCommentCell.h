//
//  GLCommunity_PostCommentCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommunity_PostCommentModel.h"

@protocol GLCommunity_PostCommentCellDelegate <NSObject>

- (void)pushController:(NSInteger)index;

@end

@interface GLCommunity_PostCommentCell : UITableViewCell

@property (nonatomic, strong)mainModel *model;

@property (nonatomic, weak)id <GLCommunity_PostCommentCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
