//
//  GLMine_SetupController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetupController.h"
#import "GLMine_SetupCell.h"
#import "GLMine_Set_modifyPwdController.h"

@interface GLMine_SetupController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSString *memory;//内存

@end

@implementation GLMine_SetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"系统设置";
    self.quitBtn.layer.cornerRadius = 5.f;
     [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetupCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetupCell"];
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)signOut:(id)sender {
    
    [UserModel defaultUser].loginstatus = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UserModel defaultUser].loginstatus = NO;
        [UserModel defaultUser].portrait = @"";
        [UserModel defaultUser].acc_id = @"";
        [UserModel defaultUser].token = @"";
        [UserModel defaultUser].userId = @"";
        //        [UserModel defaultUser].usrtype = @"0";
        [usermodelachivar achive];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"suckEffect";

        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetupCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.titleArr[indexPath.row];
    if(indexPath.row == 3){
        cell.detailLabel.text = self.memory;
        cell.detailLabel.hidden = NO;
    }else{
        cell.detailLabel.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
        {
            GLMine_Set_modifyPwdController *modifyVC = [[GLMine_Set_modifyPwdController alloc] init];
            [self.navigationController pushViewController:modifyVC animated:YES];
            
        }
            break;
        case 1:
        {
            NSLog(@"隐私");
        }
            break;
        case 2:
        {
            NSLog(@"帮助与反馈");
        }
            break;
        case 3:
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self clearFile];//清楚缓存
            }];
            
            [alertVC addAction:cancel];
            [alertVC addAction:ok];
            
            [self presentViewController:alertVC animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
}
//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath :cachPath];
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
}

-(void)clearCachSuccess{
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    
    [self.tableView reloadData];
    
    //    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
    
}
#pragma mark -
#pragma mark lazy

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"修改密码",@"隐私",@"帮助与反馈",@"清除缓存"];
    }
    return _titleArr;
}

@end
