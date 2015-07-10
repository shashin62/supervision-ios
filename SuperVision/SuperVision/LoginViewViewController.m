//
//  LoginViewViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 28/02/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import "LoginViewViewController.h"
#import "DashboardViewController.h"
#import "SVLoginRequest.h"
#import "SVLoginResponse.h"
#import "SVUserInfo.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface LoginViewViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@end

@implementation LoginViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.15 blue:0.33 alpha:1];
    
    self.loginBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.14 blue:0.2 alpha:1];
    
    self.usernameTxt.delegate = self;
    self.passwordTxt.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else if (textField == self.passwordTxt) {
        [textField resignFirstResponder];
        [self loginActionEvent:nil];
        
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.usernameTxt setText:@""];
    [self.passwordTxt setText:@""];
//    [self registerForKeyboardNotifications];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)loginActionEvent:(id)sender{
    
    [self.usernameTxt resignFirstResponder];
     [self.passwordTxt resignFirstResponder];
    
    if(self.usernameTxt.text.length>0 && self.passwordTxt.text.length>0)
    {
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    SVLoginRequest *loginRequest = [[SVLoginRequest alloc] initWithUserName:self.usernameTxt.text password:self.passwordTxt.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [networkApi loginWithCompletionBlock:loginRequest completionHandler:^(SVLoginResponse *output, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [message show];
            });
            
        }else{
            
            if([output.uId isEqualToString:@"0"] || [output.chavi isEqualToString:@"No"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [message show];
                });
                
            }else{
            AppDelegate *appDelegateObject = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            [appDelegateObject.userInfo setUId:output.uId];
            [appDelegateObject.userInfo setChavi:output.chavi];
            [appDelegateObject.userInfo setAudioRecordMessage:output.audioTextReadMessage];
            [appDelegateObject.userInfo setAppId:output.appId];
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DashboardViewController *dashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewControllerStoryBoardId"];
                [self.navigationController pushViewController:dashboardViewController animated:YES];
                });
            }
        }
    }];
    }else{
        UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter username or password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [message show];
    }
    
}


@end
