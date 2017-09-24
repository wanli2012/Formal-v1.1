//
//  GLCommentCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommentListModel.h"
#import "LWLabel.h"

@protocol GLCommentCellDelegate <NSObject>

- (void)commentPersonInfo:(NSInteger)index;//评论人个人信息
- (void)otherPersonInfo:(NSInteger)index;//被回复人的个人信息

@end

@interface GLCommentCell : UITableViewCell

@property (nonatomic, strong)commentModel *model;

@property (weak, nonatomic) IBOutlet LWLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentV;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, weak)id <GLCommentCellDelegate> delegate;


@end
