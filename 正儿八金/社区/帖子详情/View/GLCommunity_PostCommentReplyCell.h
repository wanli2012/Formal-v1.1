//
//  GLCommunity_PostCommentReplyCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommunity_PostCommentModel.h"

@interface GLCommunity_PostCommentReplyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong)replyModel *model;

@end
