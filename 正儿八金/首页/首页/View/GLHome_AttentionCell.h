//
//  GLHome_AttentionCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHome_AttentionModel.h"
#import "GLCommunity_PostCommentModel.h"
#import "GLHome_Search_PostModel.h"
#import "GLCommunity_DetailModel.h"

@protocol GLHome_AttentionCellDelegate <NSObject>

@optional
- (void)praise:(NSInteger)index;//点赞
- (void)comment:(NSInteger)index;//评论
- (void)personInfo:(NSInteger)index;//个人中心
- (void)follow:(NSInteger)index;//关注

- (void)postPraise:(NSInteger)index;//帖子详情里的点赞

- (void)clickToBigImage:(NSInteger)cellIndex index:(NSInteger)index;

@end

@interface GLHome_AttentionCell : UITableViewCell

@property (nonatomic, strong)GLHome_AttentionModel *model;
@property (nonatomic, strong)GLCommunity_PostCommentModel *postModel;
@property (nonatomic, strong)GLHome_Search_PostModel *search_postModel;
@property (nonatomic, strong)GLCommunity_Detail_elite *community_Post;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLHome_AttentionCellDelegate> delegate;

@end
