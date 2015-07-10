//
//  SVUtility.m
//  SuperVision
//
//  Created by Sachin Soni on 07/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import "SVUtility.h"
#import "AppDelegate.h"

@implementation SVUtility


+ (void) showLoadingIndicator:(UIViewController*)viewController
{
    [self showLoadingIndicator:viewController shouldResetToViewSize:NO];
}

+ (void) showLoadingIndicator:(UIViewController *)viewController shouldResetToViewSize:(BOOL)resetToViewSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate showLoading:viewController shouldResizeToViewSize:resetToViewSize];
    });
}

+ (void) hideLoadingIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate hideLoading];
        
    });
}
@end
