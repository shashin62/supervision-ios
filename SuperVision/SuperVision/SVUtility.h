//
//  SVUtility.h
//  SuperVision
//
//  Created by Sachin Soni on 07/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVUtility : NSObject

+ (void) showLoadingIndicator:(UIViewController *)viewController;
+ (void) showLoadingIndicator:(UIViewController *)viewController shouldResetToViewSize:(BOOL)resetToViewSize;
+ (void) hideLoadingIndicator;

@end
