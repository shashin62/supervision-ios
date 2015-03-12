//
//  ChangeAddressViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 09/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "ChangeAddressViewController.h"

@interface ChangeAddressViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtAddress1;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress2;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

-(IBAction)continueActionEvent:(id)sender;
@end

@implementation ChangeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)continueActionEvent:(id)sender{
    
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
