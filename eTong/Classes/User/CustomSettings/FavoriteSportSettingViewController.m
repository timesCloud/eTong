//
//  FavoriteSportSettingViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "FavoriteSportSettingViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "ShareInstances.h"
#import "selectableTableViewCell.h"

@interface FavoriteSportSettingViewController()<NormalNavigationDelegate, UITableViewDelegate, UITableViewDataSource, SelectableTableViewCellDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation FavoriteSportSettingViewController{
    NSMutableArray *sportArray;
    NSMutableArray *favoriteSportArray;
    
    AVRelation *relation;
}

- (instancetype)init{
    self = [super init];
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"钟爱运动" withRightButtonTitle:@"确定"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom + 5, self.view.width, 44)];
    [selectedView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addTopBottomBorderOnView:selectedView];
    [self.view addSubview:selectedView];

    _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, selectedView.width - 20, 14)];
    [_selectedLabel setTextColor:MAIN_COLOR];
    [_selectedLabel setTextAlignment:NSTextAlignmentLeft];
    [_selectedLabel setFont:[UIFont systemFontOfSize:14]];
    [selectedView addSubview:_selectedLabel];
    
    AVQuery *query = [AVQuery queryWithClassName:@"sportCategory"];
    [query orderByAscending:@"order"];
    [SVProgressHUD showWithStatus:@"正在获取运动类别"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            sportArray = [[NSMutableArray alloc] init];
            for (AVObject *sport in objects) {
                [sportArray addObject:sport];
            }
            if (favoriteSportArray != nil && _tableView == nil) {
                [self createTableView];
            }
            [SVProgressHUD dismiss];
        } else {
            [ShareInstances NormalNetworkErrorHUD];
        }
    }];
    
    relation = [[AVUser currentUser] relationforKey:@"favoriteSport"];
    AVQuery *favoriteQuery = [relation query];
    [favoriteQuery orderByAscending:@"order"];
    [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            favoriteSportArray = [[NSMutableArray alloc] init];
            for (AVObject *sport in objects) {
                [favoriteSportArray addObject:sport];
            }
            [self reloadSelectedLabel];
            if (sportArray != nil && _tableView == nil) {
                [self createTableView];
            }
            [SVProgressHUD dismiss];
        }else{
            [ShareInstances NormalNetworkErrorHUD];
        }
    }];
    
    return self;
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom + 44 + 5, self.view.width, self.view.height - _navigationBar.bottom - 10 - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick{
    [SVProgressHUD showWithStatus:@"正在更新运动喜好"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([_delegate respondsToSelector:@selector(favoriteSportChanged)]) {
                [_delegate favoriteSportChanged];
            }
            [SVProgressHUD dismiss];
        } else {
            [ShareInstances NormalNetworkErrorHUD];
        }
    }];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate and UiTableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [sportArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"IndustryCell";
    SelectableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[SelectableTableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AVObject *sport = [sportArray objectAtIndex:indexPath.row];
    [cell setTitle:[sport objectForKey:@"categoryName"] withObjectIndex:indexPath.row selected:[favoriteSportArray containsObject:sport]];

    cell.delegate = self;
    return cell;
}

- (void)cellSelectionChanged:(BOOL)selected withObjectIndex:(NSInteger)index{
    AVObject *changedSport = [sportArray objectAtIndex:index];
    if (selected) {
        [favoriteSportArray addObject:changedSport];
        [relation addObject:changedSport];
    } else{
        [favoriteSportArray removeObject:changedSport];
        [relation removeObject:changedSport];
    }
    
    [self reloadSelectedLabel];
    

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSelectedLabel{
    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (AVObject *sport in favoriteSportArray) {
        [tempString appendFormat:@"%@  ", [sport objectForKey:@"categoryName"]];
    }
    [_selectedLabel setText:tempString];
}

@end
