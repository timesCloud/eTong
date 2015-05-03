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
#import "StadiumView.h"
#import "SettingHomeView.h"
#import "StadiumTableViewDND.h"
#import "StadiumDetailViewController.h"
#import "CityListViewController.h"
#import "EAIntroView.h"
#import "SorryView.h"

@interface RootViewController () <SignInDelegate, SidebarViewDelegate,
    StadiumOuterDelegate, CityListDelegate> {
    UIView *navigationBar;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UIView *currentActiveView;
}

@property (nonatomic, strong) SidebarViewController* sidebarVC;
@property (nonatomic, strong) StadiumView *stadiumView;
@property (nonatomic, strong) SettingHomeView *settingHomeView;
@property (nonatomic, strong) SorryView *sorryView;
@property (nonatomic, strong) UIButton *cityButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNavigationBar];
    
    if (scrollView == nil) {
        CGRect scrollViewFrame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT);
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self.view addSubview:scrollView];
    }
    
//    if (mainMenu == nil) {
//        mainMenu = [[CommonMenu alloc] initWithRootController:self];
//        mainMenu.delegate = self;
//        [self.view addSubview:mainMenu.sideSlipView];
//    }
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    NSArray *items = @[@{@"title":@"活动",@"imagenormal":@"featured_normal.png",@"imagehighlight":@"featured_highlight.png"},
                       @{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                       @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                       @{@"title":@"赛事",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                       //@{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                       //@{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                       @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
    [self.sidebarVC setItems:items];
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
        
        _cityButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + self.view.frame.size.width - NAVIGATION_BUTTON_RESPONSE_WIDTH, STATU_BAR_HEIGHT,NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
        [_cityButton setImage:[UIImage imageNamed:@"down_normal.png"] forState:UIControlStateNormal];
        [_cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_BUTTON_WIDTH + 15, 0, 0)];
        [_cityButton setTitle:[[AVUser currentUser] objectForKey:@"city"] forState:UIControlStateNormal];
        [_cityButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        //searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cityButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cityButton setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 25)];
        [_cityButton addTarget:self action:@selector(doSelectCity) forControlEvents:UIControlEventTouchUpInside];
        [self->navigationBar addSubview:_cityButton];
        
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
    switch (index) {
        case 1:
            if (_stadiumView == nil) {
                CGRect frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
                _stadiumView = [[StadiumView alloc] initWithFrame:frame withController:self];
                //[_stadiumView forceRefresh];
            }
            newView = _stadiumView;
            title = @"找场馆";
            break;
        case 4:
            if (_settingHomeView == nil) {
                CGRect frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
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

#pragma mark SignInDelegate
- (void)onLogin {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onUserHome {
    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

#pragma mark StadiumOuterDelegate
- (void)showStadium:(Stadium *)stadium {
    StadiumDetailViewController *sdVC = [[StadiumDetailViewController alloc] init];
    [sdVC initializeWithStadium:stadium];
    [self.navigationController pushViewController:sdVC animated:YES];
}

#pragma mark CityListDelegate
- (void)citySelected:(NSString *)cityName {
    [_cityButton setTitle:cityName forState:UIControlStateNormal];
}

@end
