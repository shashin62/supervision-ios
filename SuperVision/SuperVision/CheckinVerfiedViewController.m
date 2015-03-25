//
//  CheckinVerfiedViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "CheckinVerfiedViewController.h"
#import "DashboardViewController.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface CheckinVerfiedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)homeButtonActionEven:(id)sender;
@end

@implementation CheckinVerfiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.btnHome.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    self.title = @"Check In Verified";
    [self doMobileCheckin];
}

-(void)doMobileCheckin{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.userInfoChangedRequestParam setObject:@"Mobile Check In" forKey:@"title"];
    [appDelegate.userInfoChangedRequestParam setObject:@"Mobile Check In" forKey:@"description"];
    [appDelegate.userInfoChangedRequestParam setObject:appDelegate.userInfo.uId forKey:@"UserID"];
    [appDelegate.userInfoChangedRequestParam setObject:appDelegate.userInfo.appId forKey:@"AppointmentID"];
    [appDelegate.userInfoChangedRequestParam setObject:appDelegate.longitude forKey:@"lng"];
    [appDelegate.userInfoChangedRequestParam setObject:appDelegate.latitude forKey:@"lat"];
    [appDelegate.userInfoChangedRequestParam setObject:[self getCurrentDateTimeStamp] forKey:@"CheckInDate"];

    //[params setObject:@"" forKey:@"lng"];

    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    [networkApi doMobileCheckIn:appDelegate.userInfoChangedRequestParam completionHandler:^(NSString *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if(error){
            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [message show];

        }else if([response isEqualToString:@"false"]){
            
        }else if([response isEqualToString:@"true"]){
            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"" message:@"Your Check In details have been successfully submitted." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [message show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)homeButtonActionEven:(id)sender{
    NSArray *viewContollerArray = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewContollerArray objectAtIndex:1] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)getCurrentDateTimeStamp{
    NSString *MyString = @"";
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    MyString = [dateFormatter stringFromDate:now];
    return (MyString ? MyString : @" ");
}
@end
