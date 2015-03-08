//
//  CheckinVerfiedViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "CheckinVerfiedViewController.h"
#import "DashboardViewController.h"

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

@end
