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

@end

@implementation GLCommunity_PostCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCommunity_PostCommentReplyCell" bundle:nil] forCellReuseIdentifier:@"GLCommunity_PostCommentReplyCell"];
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCommunity_PostCommentReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLCommunity_PostCommentReplyCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    return self.tableView.rowHeight;
}
@end
