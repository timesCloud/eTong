//
//  UserSummaryView.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInDelegate.h"

@interface UserSummaryView : UIView

@property (nonatomic, weak) id<SignInDelegate> delegate;

@end
