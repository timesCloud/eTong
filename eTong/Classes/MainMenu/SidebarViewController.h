//
//  SidebarViewController.h
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLBlurSidebar.h"
#import "SignInDelegate.h"

@protocol SidebarViewDelegate <NSObject>

@required
- (void)menuItemSelectedOnIndex:(NSInteger)index;

@end

@interface SidebarViewController : LLBlurSidebar

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<SidebarViewDelegate> delegate;
@property (nonatomic, weak) id<SignInDelegate> signInDelegate;

- (void)setSelectedIndex:(NSInteger)index withSection:(NSInteger)section;

@end
