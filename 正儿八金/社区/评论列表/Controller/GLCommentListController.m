//
//  GLCommentListController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommentListController.h"
#import "GLCommentCell.h"

@interface GLCommentListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;//头视图
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论View
@property (weak, nonatomic) IBOutlet UITextField *commentTF;


@end

@implementation GLCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommentCell" bundle:nil] forCellReuseIdentifier:@"GLCommentCell"];
    
    NSString *str = @"有人说世上99%的事都能用钱解决,但是他们没说,解决剩下的1%有人说世上99%的事都能用钱解决,但是他们没说,解决剩下的1%有人说世上99%的事都能用钱解决,但是他们没说,解决剩下的1%有人说世上99%的事都能用钱解决,但是他们没说,解决剩下的1%有人说世上99%的事都能用钱解决,但是他们没说,解决剩下的1%";
    
    self.commentLabel.text = str;
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    self.headerView.height = 80 + titleSize.height;
    
    self.commentView.alpha = 0;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)readThePost:(id)sender {
    NSLog(@"查看原帖子");
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommentCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.commentView.alpha = 1;
    [self.commentTF becomeFirstResponder];
    
}


//- (NSMutableArray *)dataSource{
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

@end
