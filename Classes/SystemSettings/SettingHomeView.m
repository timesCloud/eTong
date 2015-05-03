//
//  SettingHomeViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SettingHomeView.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "SVProgressHUD.h"
#import "AboutUsViewController.h"
#import "EAIntroView.h"

@interface SettingHomeView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingHomeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    return self;
}

#pragma marks UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            //return 4;
            return 2;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentity = @"systemSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setTextColor:NORMAL_TEXT_COLOR];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    for (UIView *border in cell.subviews) {
        if (border.tag == 999) {//999为SharedInstance类中为分割线赋的tag
            [border removeFromSuperview];
        }
    }
    switch (indexPath.section) {
        case 0:
            [cell.textLabel setText:@"清理缓存"];
            [ShareInstances addTopBottomBorderOnView:cell];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"意见反馈"];
                    [ShareInstances addTopBorderOnView:cell];
                    [ShareInstances addBottomSepratorBorderOnView:cell];
                    break;
                case 1:
                    [cell.textLabel setText:@"分享跑跑"];
                    [ShareInstances addBottomSepratorBorderOnView:cell];
                    break;
                case 2:
                    [cell.textLabel setText:@"去AppStore打分"];
                    [ShareInstances addBottomBorderOnView:cell];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"欢迎页"];
                    [ShareInstances addBottomSepratorBorderOnView:cell];
                    break;
                case 1:
                    //[cell.textLabel setText:@"系统通知"];
                    [cell.textLabel setText:@"关于我们"];
                    [ShareInstances addTopBorderOnView:cell];
                    [ShareInstances addBottomSepratorBorderOnView:cell];
                    break;
//                case 2:
//                    [cell.textLabel setText:@"功能简介"];
//                    [ShareInstances addBottomSepratorBorderOnView:cell];
//                    break;
//                case 3:
//                    [cell.textLabel setText:@"关于我们"];
//                    [ShareInstances addBottomBorderOnView:cell];
//                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0://清理缓存
            [self doClear];
            break;
        case 1:
            switch (indexPath.row) {
                case 0://意见反馈
                    break;
                case 1://分享跑跑
                    break;
                case 2://去AppStore打分
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
//                case 0://系统通知
//                    break;
                case 0://欢迎页
                    [self showIntroWithCrossDissolve];
                    break;
//                case 2://功能简介
//                    break;
                case 1:{//关于我们
                    AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
                    [_homeViewController.navigationController pushViewController:aboutUsVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)doClear {
    if([AVFile clearAllCachedFiles])
        [SVProgressHUD showSuccessWithStatus:@"缓存已清空" duration:2];
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"约运动，上跑跑";
    page1.desc = @"跑跑是一款运动社交应用，运动是一种时尚，更是一种生活方式";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"约运动，上跑跑";
    page2.desc = @"查找附近的球队、对手、美女，热点信息一览无余，线上约运动，简单快捷！";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"约运动，上跑跑";
    page3.desc = @"找教练，照片、资质、价格、评价、级别等信息一应俱全，资源丰富，价格透明！";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"约运动，上跑跑";
    page4.desc = @"找场地，位置、规模、环境、价格、评价等信息尽收眼底，线上支付，一锤定音！";
    page4.bgImage = [UIImage imageNamed:@"1"];
    page4.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"约运动，上跑跑";
    page5.desc = @"发布组队需求，一呼百应；寻找“组织”，快速回归！";
    page5.bgImage = [UIImage imageNamed:@"2"];
    page5.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.homeViewController.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    [intro setDelegate:self.homeViewController];
    [intro showInView:self.homeViewController.view animateDuration:0.0];
}


@end
