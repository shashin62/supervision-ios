//
//  AppDelegate.m
//  SuperVision
//
//  Created by Ashish ojha on 28/02/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.userInfo = [[SVUserInfo alloc] init];
    self.userInfoChangedRequestParam = [[NSMutableDictionary alloc] init];
    CLLocationCoordinate2D coordinate = [self getLocation];
    self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ShowLoading Indicator

- (void)showLoading:(UIViewController *)viewControllers
{
    [self showLoading:viewControllers shouldResizeToViewSize:NO];
}

- (void)showLoading:(UIViewController *)viewControllers shouldResizeToViewSize:(BOOL)shouldResizeToViewSize{
    [self initilizeLoadingViewWithSizeOfView:shouldResizeToViewSize ? viewControllers.view : nil];
    [self.loadingIndicator startAnimating];
    [viewControllers.navigationController.view addSubview:self.loadingView];
}

- (void)hideLoading {
    [self initilizeLoadingViewWithSizeOfView:nil];
    [self.loadingIndicator stopAnimating];
    [self.loadingView removeFromSuperview];
}

- (void)initilizeLoadingViewWithSizeOfView:(UIView *)view {
    
    CGRect loadingViewSize;
    
    if (view) {
        loadingViewSize = view.bounds;
        loadingViewSize.size.height += 44 + 20;
    }
    else {
        loadingViewSize = [[UIScreen mainScreen] bounds];
    }
    
    if(!self.loadingView && !self.loadingIndicator) {
        
        self.loadingView = [[UIView alloc]initWithFrame:loadingViewSize];
        [self.loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        self.loadingIndicator = [[UIActivityIndicatorView alloc] init];
        self.loadingIndicator.center = self.loadingView.center;
        [self.loadingView addSubview:self.loadingIndicator];
    }
    else {
        [self.loadingView setFrame:loadingViewSize];
        self.loadingIndicator.center = self.loadingView.center;
    }
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


@end
