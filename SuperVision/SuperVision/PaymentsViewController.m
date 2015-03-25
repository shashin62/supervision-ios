//
//  PaymentsViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "PaymentsViewController.h"
#import "RecordingViewController.h"
#import "AppDelegate.h"

@interface PaymentsViewController () <UIActionSheetDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoLbl;
@property (weak, nonatomic) IBOutlet UITextField *amountTxt;
@property (weak, nonatomic) IBOutlet UITextField *paymentMethodTxt;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UITextField *cvvTxt;

- (IBAction)doContinue:(id)sender;
- (IBAction)selectPaymentMethod:(id)sender;
@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Make Payments";
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.continueBtn.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    [self.paymentMethodTxt setText:@"Master Card 4658"];
    
    self.amountTxt.delegate = self;
    self.cvvTxt.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPaymentMethod:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Payment Method"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Master Card 4658", @"Visa 9879", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Master Card 4658"]) {
        NSLog(@"The Normal action sheet.");
        [self.paymentMethodTxt setText:@"Master Card 4658"];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Visa 9879"]){
        NSLog(@"The Delete confirmation action sheet.");
        [self.paymentMethodTxt setText:@"Visa 9879"];
    }
    else{
        NSLog(@"The Color selection action sheet.");
    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
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
    if([self validateTextField]){
//        NSString *cvvTextString = [self.cvvTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *amountString = [self.amountTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *paymentString = [self.paymentMethodTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.userInfoChangedRequestParam setObject:paymentString forKey:@"PaymentSource"];
        [appDelegate.userInfoChangedRequestParam setObject:amountString forKey:@"PaymentAmount"];
      //  [appDelegate.userInfoChangedRequestParam setObject:cityString forKey:@"OfficeCity"];

        RecordingViewController *recordingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingViewControllerStoryBoardId"];
        [self.navigationController pushViewController:recordingViewController animated:YES];

    }else{
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [message show];
    }
}

-(BOOL)validateTextField{
    NSString *cvvTextString = [self.cvvTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *amountString = [self.amountTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *paymentString = [self.paymentMethodTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    BOOL isValid = NO;
    if([cvvTextString length] && [amountString length] && [paymentString length]){
        isValid = YES;
    }
    return isValid;
}

-(void)dealloc{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"PaymentSource"];
    [appDelegate.userInfoChangedRequestParam removeObjectForKey:@"PaymentAmount"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
