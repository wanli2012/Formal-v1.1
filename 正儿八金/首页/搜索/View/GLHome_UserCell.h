//
//  GLHome_UserCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLHome_UserCellDelegate <NSObject>

- (void)attent:(NSInteger)index;

@end

@interface GLHome_UserCell : UITableViewCell

@property (nonatomic, weak)id <GLHome_UserCellDelegate>delegate;

@property (nonatomic, assign)NSInteger index;

@end
