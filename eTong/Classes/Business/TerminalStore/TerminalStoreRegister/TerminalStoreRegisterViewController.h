//
//  TerminalStoreRegisterViewController.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TerminalStore;

@interface TerminalStoreRegisterViewController : UIViewController

-(instancetype)initWithTerminalStore:(TerminalStore *)terminalStore withMode:(NSInteger)mode;

@end
