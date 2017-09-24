//
//  GLCommunity_PostCommentReplyCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommunity_PostCommentModel.h"
#import "LWLabel.h"

typedef void(^GLCommunity_PostCommentReplyCellBlock)(NSInteger cellIndex,NSInteger index,BOOL isSecondComment);


@protocol GLCommunity_PostCommentReplyCellDelegate <NSObject>

- (void)personInfo:(NSInteger)index isSecondComment:(BOOL)isSecondComment;

@end

@interface GLCommunity_PostCommentReplyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LWLabel *contentLabel;

@property (nonatomic, strong)replyModel *model;

@property (nonatomic, copy)GLCommunity_PostCommentReplyCellBlock block;

@property (nonatomic, weak)id <GLCommunity_PostCommentReplyCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
