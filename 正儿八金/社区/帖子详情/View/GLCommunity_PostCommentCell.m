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
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.user_name;
    self.dateLabel.text = [formattime formateTimeOfDate:model.commenttiem];
    [self.praiseBtn setTitle:model.reply_laud forState:UIControlStateNormal];
    [self.commentBtn setTitle:model.reply_publish forState:UIControlStateNormal];
    
    if ([model.ctfabulous integerValue] == 1) {//已点赞
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    [self.models removeAllObjects];
    
    for (replyModel *reply in model.reply) {
       
        [self.models addObject:reply];
    }
    
    if ([model.reply_publish integerValue] > 2) {
        NSString *str = [NSString stringWithFormat:@"共%@条评论>>",model.reply_publish];
        replyModel *m = [[replyModel alloc] init];
        m.content = str;
        [self.models addObject:m];
    }
    
    [self layoutIfNeeded];
    
    [self.tableView reloadData];
}

//点赞
- (IBAction)prise:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(prise:)]) {
        [self.delegate prise:self.index];
    }
}

//评论
- (IBAction)comment:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.index];
    }
}


#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentReplyCell"];
    
    replyModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.index = indexPath.row;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSString *str = [NSString stringWithFormat:@"%@",model.nickname];
    
    typeof(self)weakSelf = self;
    
    if (model.user_name == nil && model.nickname == nil) {
        
        cell.contentLabel.text = model.content;
        cell.contentLabel.selectBlobk = nil;
        
    }else if ([str rangeOfString:@"null"].location != NSNotFound) {
        
        NSString *str = [NSString stringWithFormat:@"%@:%@",model.user_name,model.content];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(0, model.user_name.length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
        
        cell.contentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.user_name.length))];
        
        cell.contentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
            
            if ([weakSelf.delegate respondsToSelector:@selector(personInfo:cellIndex:isSecommend:)]) {
                [weakSelf.delegate personInfo:indexPath.row cellIndex:self.index isSecommend:YES];
            }
        };
        
        cell.contentLabel.attributedText = noteStr;
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"%@回复%@: %@",model.user_name,model.nickname,model.content];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(0, model.user_name.length);
        NSRange redRange2 = NSMakeRange(model.user_name.length + 2, model.nickname.length);
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange2];
        
        cell.contentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.user_name.length)),NSStringFromRange(NSMakeRange(model.user_name.length + 2, model.nickname.length))];
        
        
        cell.contentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
            
            if ([self.delegate respondsToSelector:@selector(personInfo:cellIndex:isSecommend:)]) {
                
                if (index == 0) {
                    [weakSelf.delegate personInfo:indexPath.row cellIndex:self.index isSecommend:YES];
                    
                }else{
                    
                    [weakSelf.delegate personInfo:indexPath.row cellIndex:self.index isSecommend:NO];
                }
            }
            
        };
        
        cell.contentLabel.attributedText = noteStr;
        
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(pushController:)]) {
        [self.delegate pushController:self.index];
    }
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
