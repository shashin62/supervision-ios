//
//  AppointmentsViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import "AppointmentsViewController.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "AppointmentTableViewCell.h"
#import "SVAppoinmentinfo.h"
#import "AppDelegate.h"

@interface AppointmentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *officerName;

//-(void)getAppointmentsFromServer;
@end

@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.appointmentTableView registerNib:[UINib nibWithNibName:@"AppointmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppointmentTableViewCell"];

    self.appointmentTableView.dataSource = self;
    self.appointmentTableView.delegate = self;
    
    self.title = @"Appoitnments";
//    [self getAppointmentsFromServer];
    SVAppoinmentinfo *appointmentInfoObject = [self.appointmentArray objectAtIndex:0];
    self.officerName.text = appointmentInfoObject.appointmentOfficer;
     [self.officerName sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appointmentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentTableViewCell"];
    SVAppoinmentinfo *attachmentInfoObject = [self.appointmentArray objectAtIndex:indexPath.row];
    [cell.appointmentName setText:[NSString stringWithFormat:@"%@ - %@",attachmentInfoObject.appointmentName,attachmentInfoObject.appointmentStatus]];
    [cell.appointmentTime setText:[self getDateStringFromFormat:@"yyyy-MM-dd HH:mm:ss" ToFormatString:@"MMM/d/yyyy HH:mm:ss" WithInputDateString: attachmentInfoObject.appointmentCreateDate]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Network Action Methods
//
//-(void)getAppointmentsFromServer{
//    AppDelegate *appDelegateObject = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [networkApi getAppoinmentList:appDelegateObject.userInfo.uId completionHandler:^(NSArray *output, NSError *error) {
//        if(error){
//        UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [message show];
//        }else{
//            if(output)
//            self.appointmentArray = output;
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.appointmentTableView reloadData];
//        });
//
//    }];
//}

- (NSString*)getDateStringFromFormat:(NSString*)oldFormat ToFormatString:(NSString*)newFormat WithInputDateString:(NSString*)dateString{
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dfTime = [[NSDateFormatter alloc] init];
    [dfTime setDateFormat:oldFormat];
    NSDate *dtTime = [dfTime dateFromString:dateString];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:newFormat];
    NSString *newDateString = [df stringFromDate:dtTime];
    return newDateString;
}


@end
