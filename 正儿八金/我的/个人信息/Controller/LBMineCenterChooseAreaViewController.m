//
//  LBMineCenterChooseAreaViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterChooseAreaViewController.h"

@interface LBMineCenterChooseAreaViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerview;

@property (strong, nonatomic)NSString *resultStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;
@property (strong, nonatomic)NSString *provinceStr;
//@property (strong, nonatomic)LoadWaitView *loadV;

@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;
@property (strong, nonatomic)NSString *resultStrId;

@property (assign, nonatomic)NSInteger provinceRow;
@property (assign, nonatomic)NSInteger cityRow;
@property (assign, nonatomic)NSInteger condutryRow;

@end

@implementation LBMineCenterChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _provinceStrId=@"";
    _cityStrId=@"";
    _countryStrId=@"";
    _resultStrId = @"";
    _provinceStr=@"";
    _cityStr=@"";
    _countryStr=@"";
    _resultStr = @"";
    self.provinceRow = 0;
    self.cityRow = 0;
    self.condutryRow = 0;
    
    [self getPickerData];
}

#pragma mark - get data
-(void)getPickerData {
//    self.dataArr = responseObject[@"data"];
    self.cityArr = self.dataArr[0][@"city"];
    self.countryArr = self.dataArr[0][@"city"][0][@"area"];
    
    _provinceStrId = self.dataArr[0][@"id"];
    _provinceStr = self.dataArr[0][@"name"];
    _cityStrId = self.cityArr[0][@"id"];
    _cityStr = self.cityArr[0][@"name"];
    _countryStrId = self.countryArr[0][@"id"];
    _countryStr = self.countryArr[0][@"name"];
    
    [self.pickerview reloadAllComponents];
    
}

- (IBAction)canelbutton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
    
}

- (IBAction)ensurebutton:(UIButton *)sender {
    
    if (_cityStrId.length<=0) {
        _resultStrId = [NSString stringWithFormat:@"%@&%@&%@",_provinceStrId,_provinceStrId,_provinceStrId];
        _resultStr = [NSString stringWithFormat:@"%@",_provinceStr];
         _countryStrId =_provinceStrId;
        _cityStrId =_provinceStrId;
    }
    
    else if (_countryStrId.length <= 0) {
        
        _resultStrId = [NSString stringWithFormat:@"%@&%@&%@",_provinceStrId,_cityStrId,_cityStrId];
        _resultStr = [NSString stringWithFormat:@"%@%@",_provinceStr,_cityStr];
        _countryStrId =_cityStrId;
    }
    else{
    
        _resultStrId = [NSString stringWithFormat:@"%@&%@&%@",_provinceStrId,_cityStrId,_countryStrId];
         _resultStr = [NSString stringWithFormat:@"%@%@%@",_provinceStr,_cityStr,_countryStr];
    
    }
    
    if (self.returnreslut) {
        self.returnreslut(_resultStr,_resultStrId,_provinceStrId,_cityStrId,_countryStrId);
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

/**< 行*/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.dataArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    } else {
        return self.countryArr.count;
    }
    return 0;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *displaylable;
    
    displaylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 1, (self.view.bounds.size.width - 20)/3, 48)];
    displaylable.textAlignment=NSTextAlignmentCenter;
    displaylable.backgroundColor=[UIColor whiteColor];
    displaylable.textColor=[UIColor darkGrayColor];
    displaylable.font=[UIFont boldSystemFontOfSize:14];
    displaylable.numberOfLines=0;
    
    if (component == 0) {
        displaylable.text = [self.dataArr objectAtIndex:row][@"name"];
       
        
    } else if (component == 1) {
        displaylable.text = [self.cityArr objectAtIndex:row][@"name"];
       
        
    } else if (component == 2){
         displaylable.text = [self.countryArr objectAtIndex:row][@"name"];
        
    }
    
    UIView *maskview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width - 20)/3, 50)];
    maskview.backgroundColor=[UIColor whiteColor];
    [maskview addSubview:displaylable];
    
    
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = YYSRGBColor(40, 150, 58, 1);
        }
    }
    
    return maskview;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return (self.view.bounds.size.width - 20)/3;/**< 宽度*/
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;/**< 高度*/
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        self.provinceRow = row;
        self.cityArr = self.dataArr[row][@"city"];
        self.countryArr = self.dataArr[row][@"city"][0][@"area"];
        
        _provinceStrId = self.dataArr[row][@"id"];
        _provinceStr = self.dataArr[row][@"name"];
        _cityStrId = self.cityArr[0][@"id"];
        _cityStr = self.cityArr[0][@"name"];
        _countryStrId = self.countryArr[0][@"id"];
        _countryStr = self.countryArr[0][@"name"];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    
    if (component == 1) {
        self.cityRow = row;
        self.countryArr = self.dataArr[self.provinceRow][@"city"][row][@"area"];
        
        if (self.countryArr.count > 0) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
            _cityStrId = self.cityArr[row][@"id"];
            _cityStr = self.cityArr[row][@"name"];
            _countryStrId = self.countryArr[0][@"id"];
            _countryStr = self.countryArr[0][@"name"];
        }else{
        
            [pickerView selectRow:0 inComponent:2 animated:YES];
//            _cityStrId = self.cityArr[row][@"city_code"];
//            _cityStr = self.cityArr[row][@"city_name"];
//            _countryStrId = self.countryArr[0][@"country_code"];
//            _countryStr = self.countryArr[0][@"country_name"];
        
        }
    }
    
    [pickerView reloadComponent:2];
    
    if (component == 2) {
        self.condutryRow = row;
        _countryStrId = self.countryArr[row][@"id"];
        _countryStr = self.countryArr[row][@"name"];
    }
    
//    if (component == 0) {
//        _provinceStrId = self.dataArr[self.provinceRow][@"province_code"];
//        _provinceStr = self.dataArr[self.provinceRow][@"province_name"];
//    }else if (component == 1){
//        _cityStrId = self.cityArr[self.cityRow][@"city_code"];
//        _cityStr = self.cityArr[self.cityRow][@"city_name"];
//    }else if (component == 2){
//        _countryStrId = self.countryArr[self.condutryRow][@"country_code"];
//        _countryStr = self.countryArr[self.condutryRow][@"country_name"];
//    }
    
}


@end
