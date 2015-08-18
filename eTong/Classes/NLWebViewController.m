//
//  NLWebViewController.m
//  eTong
//
//  Created by 徐乃龙 on 15/8/18.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "NLWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Defines.h"
@interface NLWebViewController ()<UIWebViewDelegate>

@end

@implementation NLWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *showMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, 10, 20)];
    [showMenuButton setImage:[UIImage imageNamed:@"back_normal@2x"] forState:UIControlStateNormal];
    [showMenuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:showMenuButton];
    
    // 1.创建UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    // 2.加载登录页面
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
  //  NSURL *url=[NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // 3.设置代理
    webView.delegate = self;

}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
   // NSLog(@"ffff");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIWebViewDelegate
/**
 *  UIWebView开始加载资源的时候调用(开始发送请求)
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[MBProgressHUD showMessage:@"正在加载中..."];
}

/**
 *  UIWebView加载完毕的时候调用(请求完毕)
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[MBProgressHUD hideHUD];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
