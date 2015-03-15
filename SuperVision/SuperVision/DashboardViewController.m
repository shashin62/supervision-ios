//
//  DashboardViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"

#import "MBProgressHUD.h"
#import "SVNetworkApi.h"
#import "SVAppoinmentinfo.h"
#import "AppointmentsViewController.h"



@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *notificationLbl;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UIView *appointmentView;
@property (weak, nonatomic) IBOutlet UIButton *reportInBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointmentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) NSArray *appointmentArray;

-(void)checkTodayMobileCheckin;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.reportView.backgroundColor = [UIColor colorWithRed:0.57 green:0.78 blue:0.83 alpha:1];
//    self.reportView.tintColor = [UIColor colorWithRed:0.57 green:0.78 blue:0.83 alpha:1];
    self.paymentView.backgroundColor = [UIColor colorWithRed:0.81 green:0.27 blue:0.33 alpha:1];

    self.appointmentView.backgroundColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.37 alpha:1];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    
    self.title = @"Menu";
    [self.navigationItem setHidesBackButton:YES];
    [self checkTodayMobileCheckin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getAppointmentsFromServer];
    self.reportInBtn.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak DashboardViewController *dashboardVC = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [dashboardVC getAppointmentsFromServer];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogout:(id)sender
{
    AppDelegate *appDelegateObject = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegateObject.userInfoChangedRequestParam removeAllObjects];
    [appDelegateObject.userInfo resetAllValues];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ManageReportIn Event

-(void)checkTodayMobileCheckin{
    if ([self.appointmentArray count]) {
//        NSLog(@"%", self.appointmentArray);
        for (SVAppoinmentinfo *infoObject  in self.appointmentArray) {
            if ([infoObject.appointmentStatus isEqualToString:@"Today"]) {
             self.notificationLbl.text = @"You have check-in for today.";
                self.reportInBtn.enabled = YES;
                break;
            }
        }
    }
    
}


-(void)getAppointmentsFromServer{
    AppDelegate *appDelegateObject = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    
    [networkApi getAppoinmentList:appDelegateObject.userInfo.uId completionHandler:^(NSArray *output, NSError *error) {
        if(error){
            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [message show];
        }else{
            if(output)
                self.appointmentArray = output;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.appointmentTableView reloadData];
            [self checkTodayMobileCheckin];
        });
        
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"appointments"]){
        AppointmentsViewController *appoinmentsViewController = [segue destinationViewController];
        appoinmentsViewController.appointmentArray = self.appointmentArray;
        [appoinmentsViewController.appointmentTableView reloadData];
    }

    
}

@end
