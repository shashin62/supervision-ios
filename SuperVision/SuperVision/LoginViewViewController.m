//
//  LoginViewViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 28/02/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "LoginViewViewController.h"

@interface LoginViewViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.15 blue:0.33 alpha:1];
    
    self.loginBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.14 blue:0.2 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

- (void)doLogin
{
    
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.usernameTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else if (textField == self.passwordTxt) {
        [self doLogin];
    }
    return YES;
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
