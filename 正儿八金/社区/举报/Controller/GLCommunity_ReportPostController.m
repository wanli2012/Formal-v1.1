//
//  GLCommunity_ReportPostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/2.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_ReportPostController.h"
#import "GLCommunity_ReportCell.h"
#import "GLCommunity_ReportModel.h"

@interface GLCommunity_ReportPostController ()<UICollectionViewDelegate,UICollectionViewDataSource,GLCommunity_ReportCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;//标题,内容

@property (nonatomic, strong)NSMutableArray *dataSourceArr;//数据源
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)GLCommunity_ReportModel *model;

@end

@implementation GLCommunity_ReportPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self postReasons];
}

- (void)setUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"举报";
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.textV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.textV.layer.borderWidth = 0.5f;
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLCommunity_ReportCell" bundle:nil] forCellWithReuseIdentifier:@"GLCommunity_ReportCell"];
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = self.name;
    
    if(self.postTitle.length == 0){
        self.titleNameLabel.text = @"内容";
        self.titleLabel.text = self.content;
    }else{
        self.titleNameLabel.text = @"标题";
        self.titleLabel.text = self.postTitle;
    }

}

- (void)postReasons {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"mid"] = self.mid;
    dic[@"group_id"] = self.group_id;
    dic[@"post_id"] = self.post_id;
    dic[@"report"] = @1;
    dic[@"port"] = @"1";
    
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_REPORT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.model = [GLCommunity_ReportModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.collectionView reloadData];
      
        }else if([responseObject[@"code"] integerValue] == NO_MORE_CODE){
            if(_page != 1){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)submit:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int i = 0;
    for (GLCommunity_rtypeModel *model in self.model.rtype) {
        if (model.isSelected) {
            NSString *key = [NSString stringWithFormat:@"type_id[%d]",i];
            dic[key] = model.type_id;
            i++;
        }
    }
    if ([self.textV.text isEqualToString:@"  举报描述:15字以上,60字以内"]) {
        self.textV.text = @"";
    }
    if (i == 0) {
        if ([self.textV.text isEqualToString:@"  举报描述:15字以上,60字以内"] || self.textV.text.length == 0) {
            [MBProgressHUD showError:@"请输入举报描述"];
            return;
        }
    }
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].userId;
    dic[@"group"] = [UserModel defaultUser].groupid;
    dic[@"mid"] = self.mid;
    dic[@"group_id"] = self.group_id;
    dic[@"post_id"] = self.post_id;
    dic[@"report"] = @2;
    dic[@"cause"] = self.textV.text;
    dic[@"port"] = @"1";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPOST_REPORT_URL paramDic:dic finish:^(id responseObject) {
   
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if([responseObject[@"code"] integerValue] == NO_MORE_CODE){
            if(_page != 1){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
 
        
    } enError:^(NSError *error) {
        

        [_loadV removeloadview];

        [MBProgressHUD showError:error.localizedDescription];
        
    }];
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要举报该帖子吗?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    
//    [alertVC addAction:cancel];
//    [alertVC addAction:ok];
//    [self presentViewController:alertVC animated:YES completion:nil];

}
#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.textV.textAlignment = NSTextAlignmentLeft;
    self.textV.textColor = [UIColor darkTextColor];
    self.textV.text = @"";
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        self.textV.textAlignment = NSTextAlignmentLeft;
        self.textV.textColor = [UIColor lightGrayColor];
        self.textV.text = @"  举报描述:15字以上,60字以内";
    }
    
    return YES;
}

- (void)selectReason:(NSInteger)index{
    
    GLCommunity_rtypeModel *model = self.model.rtype[index];
    model.isSelected = !model.isSelected;

    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.rtype.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_rtypeModel *model = self.model.rtype[indexPath.row];
    
    GLCommunity_ReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLCommunity_ReportCell" forIndexPath:indexPath];
    cell.model = model;
    cell.index = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kSCREEN_WIDTH - 40)/3, 40);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //在这里进行点击cell后的操作
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

@end
