//
//  GLMine_PersonInfoController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_SetupCell.h"

@interface GLMine_PersonInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetupCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetupCell"];
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].portrait] placeholderImage:[UIImage imageNamed:@"个人信息头像底"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 修改头像
- (IBAction)modifyThePic:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像修改" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        // 设置选择后的图片可以被编辑
        
        //1.获取媒体支持格式
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = @[mediaTypes[0]];
        //5.其他配置
        //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
        picker.allowsEditing = YES;
        //6.推送
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            // 设置拍照后的图片可以被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:picture];
    [alertVC addAction:camera];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        UIImage *picImage = [UIImage imageWithData:data];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].userId;
        dict[@"group"] = [UserModel defaultUser].groupid;
        dict[@"type"] = @"2";
        dict[@"file_type"] = @"1";
        dict[@"user_name"] = [UserModel defaultUser].user_name;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kMODIFY_INFO_URL] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (picImage) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(picImage);
                [formData appendPartWithFileData:data name:@"portrait" fileName:fileName mimeType:@"image/png"];
            }
            
        }progress:^(NSProgress *uploadProgress){
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([dic[@"code"]integerValue] == SUCCESS_CODE) {
                
                self.picImageV.image = [UIImage imageWithData:data];
                
                [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
                
            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"message"]];
            }
            
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_SetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetupCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    cell.detailLabel.hidden = NO;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.detailLabel.text = self.valueArr[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.arrowImageV.hidden = YES;
    }else{
        cell.arrowImageV.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"名字");
        }
            break;
        case 1:
        {
            NSLog(@"账号");
        }
            break;
        case 2:
        {
            NSLog(@"所在位置");
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazy
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"名字",@"账号",@"所在位置"];
    }
    return _titleArr;
}

- (NSArray *)valueArr{
    if (!_valueArr) {
        _valueArr = @[@"花草树木",@"12345677",@"成都金牛万达写字楼"];
    }
    return _valueArr;
}

@end
