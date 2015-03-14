//
//  ChangeAddressViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 09/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "ChangeEmployerAddressViewController.h"
#import "PaymentsViewController.h"
#import "RecordingViewController.h"
#import "AppDelegate.h"

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
    if([self validateTextField]){
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
            [appDelegate.userInfoChangedRequestParam setObject:addressString1 forKey:@"HomeAddress1"];
            [appDelegate.userInfoChangedRequestParam setObject:cityString forKey:@"HomeCity"];
            [appDelegate.userInfoChangedRequestParam setObject:phoneString forKey:@"HomePhone"];
            [appDelegate.userInfoChangedRequestParam setObject:stateString forKey:@"HomeState"];
            [appDelegate.userInfoChangedRequestParam setObject:zipString forKey:@"HomeZip"];
        if(addressString2)
            [appDelegate.userInfoChangedRequestParam setObject:addressString2 forKey:@"HomeAddress2"];

        
        if(self.isJobChanged){
            ChangeEmployerAddressViewController *changeEmployerAddressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeEmployerAddressViewControllerStoryBoardId"];
            changeEmployerAddressViewController.isPaymentChanged = self.isPaymentChanged;
            [self.navigationController pushViewController:changeEmployerAddressViewController animated:YES];
        }else if(self.isPaymentChanged)
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
    if(cityString && phoneString && stateString && zipString && (addressString1 || addressString2)){
        isValid = YES;
    }
    return isValid;
}


-(void)dealloc{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomeAddress1"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomeAddress2"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomeCity"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomePhone"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomeState"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"HomeZip"];
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
