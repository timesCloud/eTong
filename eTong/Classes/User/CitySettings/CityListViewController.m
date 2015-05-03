//
//  CityListViewController.m
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import "CityListViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CustomLocationManager.h"
#import "ShareInstances.h"
#import "SVProgressHUD.h"

@interface CityListViewController ()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation CityListViewController{
    NSString *curCity;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"成都市",@"北京市",@"上海市",@"广州市",@"重庆市",@"深圳市", nil];
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
        
        curCity = @"正在定位中";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationUpdated:) name:KNOTIFICATION_LOCATIONUPDATED object:nil];
        [[CustomeLocationManager defaultManager] updateLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆收藏"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self getCityData];
    
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [[CustomeLocationManager defaultManager] updateLocation];
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加当前定位
    NSString *curLocation = @"位";
    [self.keys insertObject:curLocation atIndex:0];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:1];
    [self.cities setObject:_arrayHotCity forKey:strHot];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = MAIN_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"位"].location != NSNotFound) {
        titleLabel.text = @"GPS定位";
    }else if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
        NSString *key = [_keys objectAtIndex:section];
        NSArray *citySection = [_cities objectForKey:key];
        return [citySection count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:NORMAL_TEXT_COLOR];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = curCity;
    } else{
        NSString *key = [_keys objectAtIndex:indexPath.section];
        cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *city;
    if (indexPath.section == 0) {
        city = curCity;
    } else{
        NSString *key = [_keys objectAtIndex:indexPath.section];
        city = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    [[AVUser currentUser] setObject:city forKey:@"city"];
    [SVProgressHUD showWithStatus:@"正在更新城市"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([_delegate respondsToSelector:@selector(citySelected:)]) {
                [_delegate citySelected:city];
            }
            [SVProgressHUD dismiss];
        } else {
            [ShareInstances NormalNetworkErrorHUD];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onLocationUpdated:(NSNotification *)notification
{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:[ShareInstances getLastLocation] completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             curCity = city;
             NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
             [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}


@end
