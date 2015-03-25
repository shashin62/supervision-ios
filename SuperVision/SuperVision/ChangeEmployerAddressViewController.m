//
//  ChangeEmployerAddressViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 09/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "ChangeEmployerAddressViewController.h"
#import "PaymentsViewController.h"
#import "RecordingViewController.h"
#import "AppDelegate.h"

@interface ChangeEmployerAddressViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmployer;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress1;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress2;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveInfo;

-(IBAction)saveActionEvent:(id)sender;
@end

@implementation ChangeEmployerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtEmployer.delegate = self;
    self.txtAddress1.delegate = self;
    self.txtAddress2.delegate = self;
    self.txtCity.delegate = self;
    self.txtState.delegate = self;
    self.txtZip.delegate = self;
    self.txtPhone.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveActionEvent:(id)sender{
    if([self validateTextField]){
        NSString *employerString =[self.txtEmployer.text stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        NSString *addressString1 = [self.txtAddress1.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
        NSString *addressString2 = [self.txtAddress2.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
        NSString *cityString = [self.txtCity.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        NSString *phoneString =[self.txtPhone.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        NSString *stateString =[self.txtState.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        NSString *zipString = [self.txtZip.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.userInfoChangedRequestParam setObject:employerString forKey:@"CompanyName"];
        [appDelegate.userInfoChangedRequestParam setObject:addressString1 forKey:@"OfficeAddress1"];
        [appDelegate.userInfoChangedRequestParam setObject:cityString forKey:@"OfficeCity"];
        [appDelegate.userInfoChangedRequestParam setObject:phoneString forKey:@"OfficePhone"];
        [appDelegate.userInfoChangedRequestParam setObject:stateString forKey:@"OfficeState"];
        [appDelegate.userInfoChangedRequestParam setObject:zipString forKey:@"OfficeZip"];
        if(addressString2)
            [appDelegate.userInfoChangedRequestParam setObject:addressString2 forKey:@"OfficeAddress2"];
        
        if(self.isPaymentChanged)
        {
            PaymentsViewController *paymentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentsViewControllerStoryBoardId"];
            [self.navigationController pushViewController:paymentsViewController animated:YES];
        }else{
            RecordingViewController *recordingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingViewControllerStoryBoardId"];
            [self.navigationController pushViewController:recordingViewController animated:YES];
        }
    }else{
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [message show];

    }
}

-(BOOL)validateTextField{
    NSString *employerString =[self.txtEmployer.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSString *addressString1 = [self.txtAddress1.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSString *addressString2 = [self.txtAddress2.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSString *cityString = [self.txtCity.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *phoneString =[self.txtPhone.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *stateString =[self.txtState.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *zipString = [self.txtZip.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    BOOL isValid = NO;
    if([employerString length] && [cityString length] && [phoneString length] && [stateString length] && [zipString length] && ([addressString1 length] || [addressString2 length])){
        isValid = YES;
    }
    return isValid;
}


-(void)dealloc{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"CompanyName"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficeAddress1"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficeAddress2"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficeCity"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficePhone"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficeState"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"OfficeZip"];

}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtEmployer) {
        [self.txtAddress1 becomeFirstResponder];
    } else if (textField == self.txtAddress1) {
        [self.txtAddress2 becomeFirstResponder];
    } else if (textField == self.txtAddress2) {
        [self.txtCity becomeFirstResponder];
    }  else if (textField == self.txtCity) {
        [self.txtState becomeFirstResponder];
    }  else if (textField == self.txtState) {
        [self.txtZip becomeFirstResponder];
    }  else if (textField == self.txtZip) {
        [self.txtPhone becomeFirstResponder];
    } else {
        [self.txtPhone resignFirstResponder];
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
