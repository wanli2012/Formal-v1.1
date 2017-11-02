//
//  GLCommentCell.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"


@interface GLCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *priseBtn;

@end

@implementation GLCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    [self.picImageV addGestureRecognizer:tap];
    [self.nameLabel addGestureRecognizer:tap2];

}
//查看评论人
- (void)personInfo{
    if([self.delegate respondsToSelector:@selector(commentPersonInfo:)]){
        [self.delegate commentPersonInfo:self.index];
    }
}
//查看被回复人
- (void)otherPersonInfo{
    if([self.delegate respondsToSelector:@selector(otherPersonInfo:)]){
        [self.delegate otherPersonInfo:self.index];
    }
}

- (void)setModel:(commentModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if (!self.picImageV.image) {
        self.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
    }
    
    if ([model.fabulous integerValue] == 1) {//已点赞
        [self.priseBtn setImage:[UIImage imageNamed:@"赞点中"] forState:UIControlStateNormal];
    }else{
        [self.priseBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    if (model.user_name.length == 0) {
        self.nameLabel.text = model.phone;
    }else{
        self.nameLabel.text = model.user_name;
        
    }
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    [self.priseBtn setTitle:model.laud forState:UIControlStateNormal];

    NSString *str = [NSString stringWithFormat:@"%@",model.nickname];
    
    if ([str rangeOfString:@"null"].location != NSNotFound) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
        self.contentLabel.selectBlobk = nil;
        
    }else{
        NSString *str;
        if (model.nickname.length == 0) {
            
            str = [NSString stringWithFormat:@"回复%@: %@",model.mphone,model.content];
        }else{
            str = [NSString stringWithFormat:@"回复%@: %@",model.nickname,model.content];
        }
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(2, [[noteStr string] rangeOfString:@":"].location - 2);
        [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
        
        self.contentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(2, [[noteStr string] rangeOfString:@":"].location - 2))];
        
        self.contentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
            
            [self otherPersonInfo];
            
        };
        
        self.contentLabel.attributedText = noteStr;
        
    }
    
    [self.contentLabel sizeToFit];
    

}


@end
