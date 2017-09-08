//
//  GLHome_NewController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_NewController.h"
#import "GLHome_NewCell.h"

@interface GLHome_NewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLHome_NewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHome_NewCell" bundle:nil] forCellWithReuseIdentifier:@"GLHome_NewCell"];
}

#pragma  mark UICollectionViewDelegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_NewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLHome_NewCell" forIndexPath:indexPath];
    
    return cell;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kSCREEN_WIDTH - 40)/2, 150);
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

@end
