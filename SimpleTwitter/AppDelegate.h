//
//  AppDelegate.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVFloatingDrawerViewController;
//@class JVFloatingDrawerSpringAnimator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
//@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;


+ (AppDelegate*)globalDelegate;

- (void)showLeftDrawer:(id)sender animated:(BOOL)animated;
//- (void)showRightDrawer:(id)sender animated:(BOOL)animated;

@end

