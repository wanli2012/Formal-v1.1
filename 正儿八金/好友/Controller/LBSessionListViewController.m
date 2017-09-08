//
//  LBSessionListViewController.m
//  正儿八金
//
//  Created by 四川三君科技有限公司 on 2017/9/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBSessionListViewController.h"
#import "NIMSessionViewController.h"

@interface LBSessionListViewController ()<NIMLoginManagerDelegate,NIMEventSubscribeManagerDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL supportsForceTouch;

@property (nonatomic,strong) NSMutableDictionary *previews;

@property (weak, nonatomic) IBOutlet UIView *navagationView;

@end

#define SessionListTitle @"吕兵"

@implementation LBSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _previews = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.navagationView.layer.shadowColor = YYSRGBColor(207, 207, 207, 1).CGColor;
    self.navagationView.layer.shadowOffset=CGSizeMake(0, 5);
    self.navagationView.layer.shadowOpacity=0.5;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    
    
    self.emptyTipLabel = [[UILabel alloc] init];
    self.emptyTipLabel.font = [UIFont systemFontOfSize:14];
    self.emptyTipLabel.text = @"还没有会话，在通讯录中找个人聊聊吧";
    [self.emptyTipLabel sizeToFit];
    self.emptyTipLabel.hidden = YES;
    [self.tableView addSubview:self.emptyTipLabel];
    
    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];

}

- (void)refresh{
    
    self.emptyTipLabel.hidden = self.recentSessions.count;
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        UIViewController *vc;
        //        if ([[NIMSDK sharedSDK].robotManager isValidRobot:recent.session.sessionId])
        //        {
        //            vc = [[NTESRobotCardViewController alloc] initWithUserId:recent.session.sessionId];
        //        }
        //        else
        //        {
        //            vc = [[NTESPersonalCardViewController alloc] initWithUserId:recent.session.sessionId];
        //        }
        //        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    [super onDeleteRecentAtIndexPath:recent atIndexPath:indexPath];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }
    return [super nameForRecentSession:recent];
}

#pragma mark - SessionListHeaderDelegate


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
            break;
        case NIMLoginStepLinking:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
            break;
        default:
            break;
    }
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    
    [self.view setNeedsLayout];
}

- (void)onMultiLoginClientsChanged
{
    
    [self.view setNeedsLayout];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:cell];
        [self.previews setObject:preview forKey:@(indexPath.row)];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self.previews objectForKey:@(indexPath.row)];
        [self unregisterForPreviewingWithContext:preview];
        [self.previews removeObjectForKey:@(indexPath.row)];
    }
}


//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
//    UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
//        return nav;
//    }
//    return nil;
//}

//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
//    UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
//        [self.navigationController showViewController:vc sender:nil];
//    }
//}


#pragma mark - NIMEventSubscribeManagerDelegate

- (void)onRecvSubscribeEvents:(NSArray *)events
{
    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NIMSubscribeEvent *event in events) {
        [ids addObject:event.from];
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        if (recent.session.sessionType == NIMSessionTypeP2P) {
            NSString *from = recent.session.sessionId;
            if ([ids containsObject:from]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - Private

- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f;
}

- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    return titleView;
}


@end
