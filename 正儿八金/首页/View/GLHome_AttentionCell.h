//
//  GLHome_AttentionCell.h
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHome_AttentionModel.h"

@interface GLHome_AttentionCell : UITableViewCell

//@property (nonatomic, assign)NSInteger sum;

@property (nonatomic, strong)GLHome_AttentionModel *model;

@property (nonatomic, assign)BOOL isHiddenAttendBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
