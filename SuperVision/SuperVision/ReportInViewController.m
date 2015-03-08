//
//  ReportInViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "ReportInViewController.h"

@interface ReportInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation ReportInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.continueBtn.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    self.title = @"Report In";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
