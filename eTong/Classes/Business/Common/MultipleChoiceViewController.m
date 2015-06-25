//
//  FavoriteSportSettingViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "MultipleChoiceViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "ShareInstances.h"
#import "selectableTableViewCell.h"

@interface MultipleChoiceViewController()<NormalNavigationDelegate, UITableViewDelegate, UITableViewDataSource, SelectableTableViewCellDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation MultipleChoiceViewController{
    NSArray *nameArray, *objectArray;
    NSMutableArray *selectedObjectArray;
}

- (instancetype)initWithItemNames:(NSArray *)names withObjects:(NSArray *)objects withSelectedObjects:(NSArray *)selected{
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
    
    nameArray = names;
    objectArray = objects;
    selectedObjectArray = [[NSMutableArray alloc] initWithArray:selected];
    
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
    if ([_delegate respondsToSelector:@selector(multipleSelectedChanged:)]) {
        [_delegate multipleSelectedChanged:selectedObjectArray];
    }
}

#pragma mark UITableViewDelegate and UiTableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"IndustryCell";
    SelectableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[SelectableTableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSObject *object = [objectArray objectAtIndex:indexPath.row];
    NSString *name = [nameArray objectAtIndex:indexPath.row];
    [cell setTitle:name withObjectIndex:indexPath.row selected:[selectedObjectArray containsObject:object]];

    cell.delegate = self;
    return cell;
}

- (void)cellSelectionChanged:(BOOL)selected withObjectIndex:(NSInteger)index{
    NSObject *changedObject = [objectArray objectAtIndex:index];
    if (selected) {
        [selectedObjectArray addObject:changedObject];
    } else{
        [selectedObjectArray removeObject:changedObject];
    }
    
    [self reloadSelectedLabel];
    

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSelectedLabel{
    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (NSObject *object in selectedObjectArray) {
        NSInteger index = [objectArray indexOfObject:object];
        [tempString appendFormat:@"%@  ", [nameArray objectAtIndex:index]];
    }
    [_selectedLabel setText:tempString];
}

@end
