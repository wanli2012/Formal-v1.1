//
//  GLCommunity_PostController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostController.h"
#import "GLHome_AttentionCell.h"
#import "GLCommunity_PostCommentCell.h"

@interface GLCommunity_PostController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLCommunity_PostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.borderColor = MAIN_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_AttentionCell" bundle:nil] forCellReuseIdentifier:@"GLHome_AttentionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//返回按钮点击事件
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        GLHome_AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_AttentionCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
     
        GLHome_AttentionModel *model = [[GLHome_AttentionModel alloc] init];
        model.sum = @"3";
        model.content = @"shdfhslkdfhlshdflshadf;lhsa;lfhla;khgewhpigvhwoiehgviowhegoivhweiogvhwoiehgoiwhgoiwhgovihwoigvhwoiehoiwhoiwhboiwhbo";
        cell.model = model;
        return cell;
        
    }else{
        
        GLCommunity_PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44;
        
        return self.tableView.rowHeight;
        
    }else{
        
        return 300;
    }
    
}

@end
