//
//  GLCommunity_PostCommentCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostCommentCell.h"
#import "GLCommunity_PostCommentReplyCell.h"

@interface GLCommunity_PostCommentCell ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, copy)NSArray *models;

@end

@implementation GLCommunity_PostCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentReplyCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentReplyCell"];
    
}

- (void)setModel:(GLCommunity_PostCommentModel *)model{
    _model = model;
    self.commentLabel.text = model.comment;
    self.models = model.commentArr;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentReplyCell"];
    GLCommunity_PostCommentModel *model = self.models[indexPath.row];

    NSString *str = [NSString stringWithFormat:@"%@:%@",model.son_commentName,model.son_comment];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
    
    [cell.contentLabel setAttributedText:noteStr] ;
    [cell.contentLabel sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}
@end
