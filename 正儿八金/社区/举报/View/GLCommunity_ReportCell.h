//
//  GLCommunity_ReportCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/2.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCommunity_ReportModel.h"

@protocol GLCommunity_ReportCellDelegate <NSObject>

- (void)selectReason:(NSInteger)index;

@end

@interface GLCommunity_ReportCell : UICollectionViewCell

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)GLCommunity_rtypeModel *model;

@property (nonatomic, weak)id <GLCommunity_ReportCellDelegate>delegate;

@end
