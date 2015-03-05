//
//  PaymentsViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "PaymentsViewController.h"

@interface PaymentsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoLbl;
@property (weak, nonatomic) IBOutlet UITextField *amountTxt;
@property (weak, nonatomic) IBOutlet UITextField *paymentMethodTxt;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UITextField *cvvTxt;

- (IBAction)doContinue:(id)sender;

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Make Payments";
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.continueBtn.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
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

- (IBAction)doContinue:(id)sender {
}
@end
