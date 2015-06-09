//
//  ViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "RootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SidebarViewController.h"
#import "Defines.h"
#import "SignInDelegate.h"
#import "LoginViewController.h"
#import "UserHomeViewController.h"
#import "SettingHomeView.h"
#import "CityListViewController.h"
#import "EAIntroView.h"
#import "SorryView.h"
#import "ShareInstances.h"
#import "SKUView.h"
#import "UIView+XD.h"
#import "BarcodeScanViewController.h"
#import "SKU.h"
#import "SVProgressHUD.h"
#import "SKUSearchResultViewController.h"
#import "InvestigateEntryView.h"

@interface RootViewController () <SignInDelegate, SidebarViewDelegate, CityListDelegate, EAIntroDelegate> {
    UIView *navigationBar;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UIView *currentActiveView;
    NSInteger curUserCharacter;//当前用户角色，1为终端店，2为终极经销商
}

@property (nonatomic, strong) SidebarViewController* sidebarVC;
@property (nonatomic, strong) SettingHomeView *settingHomeView;
@property (nonatomic, strong) SKUView *skuView;
@property (nonatomic, strong) SorryView *sorryView;
@property (nonatomic, strong) InvestigateEntryView *investigateEntryView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation RootViewController

- (instancetype)init{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNavigationBar];
    
    if (scrollView == nil) {
        CGRect scrollViewFrame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT);
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self.view addSubview:scrollView];
    }
    
    if ([AVUser currentUser] == nil) {
        [self doSignIn];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comentityLoaded:) name:KNOTIFICATION_COMENTITYLOADED object:nil];
        [ShareInstances setCurrentTerminalStore];
        //[self reloadSubViews];
    }
}

-(void)doSignIn {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.rootViewController = self;
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)reloadSubViews{
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    [self reloadMenu];
    
    self.sidebarVC.signInDelegate = self;
    self.sidebarVC.delegate = self;
    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = self.view.bounds;
    // 左侧边栏结束
    
    //显示引导页面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self showIntroWithCrossDissolve];
    }
    
    [self.sidebarVC setSelectedIndex:1 withSection:0];
    [self menuItemSelectedOnIndex:1];//默认显示场馆页面
}

-(void)reloadMenu {
    AVUser *curUser = [AVUser currentUser];
    NSArray *items;
    if (curUser != nil) {
        curUserCharacter = [[curUser objectForKey:@"character"] integerValue];
        switch (curUserCharacter) {
            case 1:
                items = @[@{@"title":@"主页",@"imagenormal":@"home_normal.png",@"imagehighlight":@"home_highlight.png"},
                          @{@"title":@"进货/库存录入",@"imagenormal":@"sale_edit_normal.png",@"imagehighlight":@"sale_edit_highlight.png"},
                          @{@"title":@"每日一评",@"imagenormal":@"stock_edit_normal.png",@"imagehighlight":@"stock_edit_highlight.png"},
                          @{@"title":@"统计",@"imagenormal":@"stat_normal.png",@"imagehighlight":@"stat_highlight.png"},
                          @{@"title":@"需求帮帮",@"imagenormal":@"link_normal.png",@"imagehighlight":@"link_highlight.png"},
                          @{@"title":@"投诉建议",@"imagenormal":@"mail_normal.png",@"imagehighlight":@"mail_highlight.png"},
                          @{@"title":@"积分商城",@"imagenormal":@"mall_normal.png",@"imagehighlight":@"mall_highlight.png"},
                          @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
                break;
            case 2:
                items = @[@{@"title":@"活动",@"imagenormal":@"featured_normal.png",@"imagehighlight":@"featured_highlight.png"},
                          @{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                          @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                          @{@"title":@"赛事",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                          //@{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                          //@{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                          @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
                break;
            case 3:
                items = @[@{@"title":@"活动",@"imagenormal":@"featured_normal.png",@"imagehighlight":@"featured_highlight.png"},
                          @{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                          @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                          @{@"title":@"赛事",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                          //@{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                          //@{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                          @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
                break;
            default:
                break;
        }

        [self.sidebarVC setItems:items];
    }
    else {
        items = [[NSArray alloc] initWithObjects:nil];
        [self.sidebarVC setItems:items];
    }

}

-(void)loginStateChange:(NSNotification *)notification {
    if ([AVUser currentUser] == nil) {
        [self doSignIn];
    } else{
        switch ([[[AVUser currentUser] objectForKey:@"character"] integerValue]) {
            case 1:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comentityLoaded:) name:KNOTIFICATION_COMENTITYLOADED object:nil];
                [ShareInstances setCurrentTerminalStore];
                break;
            default:
                break;
        }
    }
}

-(void)comentityLoaded:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_COMENTITYLOADED object:nil];
    [self reloadSubViews];
}

//-(void)viewDidAppear:(BOOL)animated{
//    //Calling this methods builds the intro and adds it to the screen. See below.
//    //[self buildIntro];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"壹通1";
    page1.desc = @"壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"壹通2";
    page2.desc = @"壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"壹通3";
    page3.desc = @"壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"壹通4";
    page4.desc = @"壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通";
    page4.bgImage = [UIImage imageNamed:@"1"];
    page4.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"壹通5";
    page5.desc = @"壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通壹通";
    page5.bgImage = [UIImage imageNamed:@"2"];
    page5.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}


- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.sidebarVC panDetected:recoginzer];
}

- (void)initNavigationBar {
    if (navigationBar == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, STATU_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
        navigationBar = [[UIView alloc] initWithFrame:frame];
        [self.view addSubview:navigationBar];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:navigationBar.frame];
        [background setImage:[UIImage imageNamed:@"navigationBackground.png"]];
        [navigationBar addSubview:background];
        
        UIButton *showMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
        [showMenuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [showMenuButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_LBUTTON_MARGIN_LEFT, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_LBUTTON_MARGIN_LEFT-NAVIGATION_BUTTON_WIDTH)];
        [showMenuButton addTarget:self action:@selector(doPopMainMenu:) forControlEvents:UIControlEventTouchUpInside];
        [showMenuButton setContentMode:UIViewContentModeLeft];
        [self->navigationBar addSubview:showMenuButton];
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + self.view.frame.size.width - NAVIGATION_BUTTON_RESPONSE_WIDTH, STATU_BAR_HEIGHT,NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
        [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, NAVIGATION_RBUTTON_MARGIN_RIGHT)];
        [_rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightButton addTarget:self action:@selector(doSelectCity) forControlEvents:UIControlEventTouchUpInside];
        //[self->navigationBar addSubview:_rightButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + (self.view.frame.size.width - NAVIGATION_TITLE_WIDTH) / 2, STATU_BAR_HEIGHT, NAVIGATION_TITLE_WIDTH, NAVIGATION_TITLE_HEIGHT)];
        [titleLabel setTextColor:[UIColor darkTextColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self->navigationBar addSubview:titleLabel];
    }
}

- (void)doPopMainMenu:(id)sender {
    [self.sidebarVC showHideSidebar];
}

- (void)doSelectCity {
    CityListViewController *cityListVC = [[CityListViewController alloc] init];
    cityListVC.delegate = self;
    [self.navigationController pushViewController:cityListVC animated:YES];
}

#pragma mark CommonMainMenuDelegate
-(void)ShowView:(UIView *)newView withTitle:(NSString *)title withRemoveLastView:(UIView *)lastView {
    [scrollView addSubview:newView];
    [lastView removeFromSuperview];
    
    [self->titleLabel setText:title];
}

#pragma mark SidebarViewDelegate
- (void)menuItemSelectedOnIndex:(NSInteger)index {
    UIView *newView = nil;
    NSString *title = nil;
    [_rightButton removeFromSuperview];
    [_rightButton removeTarget:self action:@selector(scanBarcode) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    switch (index) {
        case 1:
            if (_skuView == nil) {
                _skuView = [[SKUView alloc] initWithFrame:frame withController:self];
            }
            newView = _skuView;
            title = @"SKU";
            [self->navigationBar addSubview:_rightButton];
            [_rightButton setImage:[UIImage imageNamed:@"barcodeScan.png"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(scanBarcode) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            if (_investigateEntryView == nil) {
                _investigateEntryView = [[InvestigateEntryView alloc] initWithFrame:frame withController:self];
            }
            newView = _investigateEntryView;
            title = @"每日一评";
            break;
        case 4:
            if (_settingHomeView == nil) {
                _settingHomeView = [[SettingHomeView alloc] initWithFrame:frame];
                _settingHomeView.homeViewController = self;
            }
            newView = _settingHomeView;
            title = @"系统设置";
            break;
        default:
            //if (_sorryView == nil) {
                _sorryView = [[SorryView alloc] initWithFrame:scrollView.bounds withController:self];
            //}
            newView = _sorryView;
            if(index == 0)
                title = @"找活动";
            else if (index == 2)
                title = @"找团队";
            else if (index == 3)
                title = @"精彩赛事";
    }

    if (currentActiveView != newView) {
        [self ShowView:newView withTitle:title withRemoveLastView:currentActiveView];
        //                [currentActiveView removeFromSuperview];
        //                [rootController.view addSubview:newView];
        //                [rootController.view sendSubviewToBack:newView];
        currentActiveView = newView;
    }
}

- (void)scanBarcode{
    BarcodeScanViewController *barcodeScanVC = [[BarcodeScanViewController alloc] init];
    
    [self.navigationController pushViewController:barcodeScanVC animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SKUScaned:) name:KNOTIFICATION_SKUSCANED object:nil];
    
}

- (void)SKUScaned:(NSNotification *)notification{
    NSString *barcode = [notification.userInfo objectForKey:@"barcode"];
    [self QuerySKUByBarcode:barcode];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_SKUSCANED object:nil];
}

- (void)QuerySKUByBarcode:(NSString *)barcode{
    [SVProgressHUD showWithStatus:@"正在查询SKU"];
    AVQuery *query = [SKU query];
    [query whereKey:@"commodityCode" equalTo:barcode];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (objects.count > 0) {
                SKU *sku = [objects objectAtIndex:0];
                SKUSearchResultViewController *SSRVC = [[SKUSearchResultViewController alloc] initWithSKU:sku];
                [self.navigationController pushViewController:SSRVC animated:NO];
//                [skuNameLable setText:sku.skuName];
//                [SVProgressHUD showWithStatus:@"正在获取SKU缩略图"];
//                [sku.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
//                    if (!error) {
//                        [SVProgressHUD dismiss];
//                        [skuImage setImage:image];
//                    } else{
//                        [SVProgressHUD showErrorWithStatus:@"缩略图获取失败" duration:2];
//                    }
//                }];
            } else{
                [SVProgressHUD showErrorWithStatus:@"该商品不在系统管理范围内" duration:2];
            }
        } else{
            [SVProgressHUD showErrorWithStatus:@"网络故障，SKU查询失败" duration:2];
        }
    }];
}

#pragma mark SignInDelegate
- (void)onLogin {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onUserHome {
    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

#pragma mark CityListDelegate
- (void)citySelected:(NSString *)cityName {
    [_rightButton setTitle:cityName forState:UIControlStateNormal];
}

@end
