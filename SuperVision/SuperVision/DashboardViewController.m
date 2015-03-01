//
//  DashboardViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "DashboardViewController.h"

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogout:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
