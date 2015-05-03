//
//  ImgShowViewController.m
//  Project-Movie
//
//  Created by Minr on 14-11-14.
//  Copyright (c) 2014年 Minr. All rights reserved.
//

#import "ImgShowViewController.h"
#import "MRImgShowView.h"

@interface ImgShowViewController ()

@end

@implementation ImgShowViewController

- (id)initWithSourceData:(NSMutableArray *)data withIndex:(NSInteger)index{
    
    self = [super init];
    if (self) {
        _data = data;
        _index = index;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"图片列表";
    
    //设置导航栏为半透明
    self.navigationController.navigationBar.translucent = YES;
    // 隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;

    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]];
    
    // 添加导航栏退回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self creatImgShow];
}

// 初始化视图
- (void)creatImgShow{
    
    MRImgShowView *imgShowView = [[MRImgShowView alloc]
                                  initWithFrame:self.view.frame
                                    withSourceData:_data
                                    withIndex:_index];
    
    // 解决谦让
    [imgShowView requireDoubleGestureRecognizer:[[self.view gestureRecognizers] lastObject]];
    
    [self.view addSubview:imgShowView];
}

#pragma mark -UIGestureReconginzer
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 隐藏导航栏
//    [UIView animateWithDuration:0.3 animations:^{
//        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
//    }];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -NavAction
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
