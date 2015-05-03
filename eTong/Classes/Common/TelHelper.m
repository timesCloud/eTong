//
//  TelHelper.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TelHelper.h"

@implementation TelHelper

+ (void)callWithParentView:(UIView *)parent phoneNo:(NSString *)phoneNo {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNo];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [parent addSubview:callWebview];
}

@end
