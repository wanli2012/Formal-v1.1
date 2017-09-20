//
//  GLCommunity_PostCommentCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommunity_PostCommentCell.h"
#import "GLCommunity_PostCommentReplyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLCommunity_PostCommentCell ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (nonatomic, copy)NSMutableArray *models;

@end

@implementation GLCommunity_PostCommentCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentReplyCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentReplyCell"];
    
}

- (void)setModel:(mainModel *)model{
    _model = model;
    
    self.commentLabel.text = model.content;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"头像1"]];
    self.nameLabel.text = model.user_name;
    self.dateLabel.text = [formattime formateTimeOfDate:model.commenttiem];
    [self.praiseBtn setTitle:model.reply_laud forState:UIControlStateNormal];
    [self.commentBtn setTitle:model.reply_publish forState:UIControlStateNormal];
    
    [self.models removeAllObjects];
    
    for (replyModel *reply in model.reply) {
       
        [self.models addObject:reply];
    }
    
    [self.tableView reloadData];
}

//点赞
- (IBAction)prise:(id)sender {
    
}
//评论
- (IBAction)comment:(id)sender {
    
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
    
    replyModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(pushController:)]) {
        [self.delegate pushController:self.index];
    }
    
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

- (NSMutableArray *)models{
    if (!_models) {
        
        _models = [NSMutableArray array];
        
    }
    return _models;
}
@end
