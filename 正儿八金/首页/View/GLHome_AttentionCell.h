//
//  GLHome_AttentionCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHome_AttentionModel.h"

@protocol GLHome_AttentionCellDelegate <NSObject>

- (void)praise:(NSInteger)index;
- (void)comment:(NSInteger)index;
- (void)personInfo:(NSInteger)index;


@end

@interface GLHome_AttentionCell : UITableViewCell

@property (nonatomic, strong)GLHome_AttentionModel *model;
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLHome_AttentionCellDelegate> delegate;

@end
