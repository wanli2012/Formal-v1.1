//
//  GLCommunityCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLCommunityCellDelegate <NSObject>

- (void)attent:(NSInteger)index;

@end

@interface GLCommunityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentLabel;//关注人数
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;//关注按钮

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id<GLCommunityCellDelegate> delegate;

@end
