//
//  AppDelegate.h
//  SuperVision
//
//  Created by Ashish ojha on 28/02/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVUserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SVUserInfo *userInfo;
@property (strong, nonatomic) NSMutableDictionary *userInfoChangedRequestParam;
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

- (void)showLoading:(UIViewController *)viewControllers;
- (void)showLoading:(UIViewController *)viewControllers shouldResizeToViewSize:(BOOL)shouldResizeToViewSize;
- (void)hideLoading;

@end

