//
//  IndustrySettingViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "IndustrySettingViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "ShareInstances.h"
#import "selectableTableViewCell.h"

@interface IndustrySettingViewController()<NormalNavigationDelegate, UITableViewDelegate, UITableViewDataSource, SelectableTableViewCellDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IndustrySettingViewController{
    NSMutableArray *industryArray;
    AVObject *originIndustry;
    AVObject *curIndustry;
    NSInteger curIndex;
}

- (instancetype)init{
    self = [super init];
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"行业类别" withRightButtonTitle:@"确定"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    industryArray = [[NSMutableArray alloc] init];
    AVQuery *query = [AVQuery queryWithClassName:@"IndustryCategory"];
    [query orderByAscending:@"order"];
    [SVProgressHUD showWithStatus:@"正在获取行业分类"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            for (AVObject *industry in objects) {
                [industryArray addObject:industry];
            }
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, _navigationBar.bottom + 5, self.view.width - 10, self.view.height - _navigationBar.bottom - 10)];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:_tableView];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取行业分类失败，请稍候重试" duration:2];
        }
    }];
    
    originIndustry = [[AVUser currentUser] objectForKey:@"industry"];;
    curIndustry = originIndustry;
    
    return self;
}

- (void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick{
    if (originIndustry != curIndustry) {
        AVUser *curUser = [AVUser currentUser];
        [curUser setObject:curIndustry forKey:@"industry"];
        [SVProgressHUD showWithStatus:@"正在更新行业"];
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if ([_delegate respondsToSelector:@selector(industryChanged)]) {
                    [_delegate industryChanged];
                }
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:@"更新失败" duration:2];
            }
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate and UiTableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [industryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"IndustryCell";
    SelectableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[SelectableTableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AVObject *industry = [industryArray objectAtIndex:indexPath.row];
    [cell setTitle:[industry objectForKey:@"categoryName"] withObjectIndex:indexPath.row selected:[curIndustry.objectId isEqualToString:industry.objectId ]];
    if ([curIndustry.objectId isEqualToString:industry.objectId]) {
        curIndex = indexPath.row;
    }
    cell.delegate = self;
    return cell;
}

- (void)cellSelectionChanged:(BOOL)selected withObjectIndex:(NSInteger)index{
    NSInteger lastIndex = curIndex;
    curIndex = index;
    curIndustry = [industryArray objectAtIndex:index];
    NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:lastIndex inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lastIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *curIndexPath=[NSIndexPath indexPathForRow:curIndex inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:curIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
