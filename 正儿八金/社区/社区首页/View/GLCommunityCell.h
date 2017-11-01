//
//  GLCommunityCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommunity_FollowModel.h"

@protocol GLCommunityCellDelegate <NSObject>

- (void)attent:(NSInteger)index;

@end

@interface GLCommunityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *attentBtn;//关注按钮

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id<GLCommunityCellDelegate> delegate;

@property (nonatomic, strong)GLCommunity_FollowModel *model;

@property (nonatomic, strong)GLCommunity_RecommendModel *recommendModel;

@end
