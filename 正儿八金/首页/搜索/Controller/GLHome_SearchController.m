//
//  GLHome_SearchController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_SearchController.h"
#import "MSSAutoresizeLabelFlow.h"
#import "GLHome_SearchDataBase.h"
#import "GLHome_Search_MainController.h"

#import "GLHome_CommunityController.h"//社区
#import "GLHome_PostController.h"//帖子
#import "GLHome_UserController.h"//用户

@interface GLHome_SearchController ()<UITextFieldDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UIView *searchView;



@property(nonatomic,strong)MSSAutoresizeLabelFlow *secondView;

@property (nonatomic, strong)NSMutableArray *fmdbArr;
@property (nonatomic, strong)NSMutableArray *reCoderArr;
@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)GLHome_SearchDataBase *dataBase;

@property (nonatomic, copy)NSString *sort;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLHome_SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.borderColor = MAIN_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.cornerRadius = 5.f;
    
    [self selectTagByIndex:0 animated:YES];
  
    [self getFmdbDatasoruce];
    self.type = @"1";
}

-(void)getFmdbDatasoruce{
    
    self.fmdbArr = nil;
    self.reCoderArr = nil;
    
    //获取本地搜索记录
    _dataBase = [GLHome_SearchDataBase greateTableOfFMWithTableName:@"GLHome_SearchDataBase"];
    if ([_dataBase isDataInTheTable]) {
        
        self.fmdbArr = [NSMutableArray arrayWithArray:[_dataBase queryAllDataOfFMDB]];
        for (int i = 0; i < [[_dataBase queryAllDataOfFMDB] count]; i++) {
            
            [self.reCoderArr addObject:[_dataBase queryAllDataOfFMDB][i][@"recoder"]];
        }
    }else{
        [self.reCoderArr removeAllObjects];
        self.fmdbArr = [NSMutableArray array];
    }
    
    _secondView = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 100, kSCREEN_WIDTH, kSCREEN_HEIGHT - 100) titles:self.reCoderArr selectedHandler:^(NSUInteger index, NSString *title) {
    
        self.searchTF.text = [NSString stringWithFormat:@"%@",self.reCoderArr[index]];
        [self.view endEditing:YES];
        
        self.hidesBottomBarWhenPushed = YES;
        GLHome_Search_MainController *searchVC = [[GLHome_Search_MainController alloc] init];
        searchVC.searchContent = self.searchTF.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.searchTF.text forKey:@"searchContent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:searchVC animated:NO];

        
    }];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addSubview:_secondView];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL isSava = YES;//是否保存
    for (int i = 0; i < self.fmdbArr.count; i++) {
        if ([self.fmdbArr[i][@"recoder"] isEqualToString:self.searchTF.text]) {
            isSava = NO;
        }
    }
    
    [self getFmdbDatasoruce];//获取最新的数据库数据
    
    if (isSava == YES) {//保存记录
        [_dataBase deleteAllDataOfFMDB];
        _dataBase = [GLHome_SearchDataBase greateTableOfFMWithTableName:@"GLHome_SearchDataBase"];
        [self.fmdbArr insertObject:@{@"recoder":self.searchTF.text} atIndex:0];
        if (self.fmdbArr.count > 10) {
            [self.fmdbArr  removeObjectsInRange:NSMakeRange(10, self.fmdbArr.count)];
        }
        [_dataBase insertOfFMWithDataArray:self.fmdbArr];
    }
    
    self.secondView.hidden = YES;
    [self.view endEditing:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    GLHome_Search_MainController *searchVC = [[GLHome_Search_MainController alloc] init];
    searchVC.searchContent = self.searchTF.text;
    [[NSUserDefaults standardUserDefaults] setObject:self.searchTF.text forKey:@"searchContent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:searchVC animated:NO];
    
    return YES;
}

#pragma 懒加载
- (NSMutableArray *)reCoderArr{
    if (!_reCoderArr) {
        _reCoderArr = [NSMutableArray array];
    }
    return _reCoderArr;
}
- (NSMutableArray *)fmdbArr{
    if (!_fmdbArr) {
        _fmdbArr = [NSMutableArray array];
    }
    return _fmdbArr;
}

@end
