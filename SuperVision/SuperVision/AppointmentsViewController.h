//
//  AppointmentsViewController.h
//  SuperVision
//
//  Created by Ashish ojha on 01/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentsViewController : UIViewController 
@property (strong, nonatomic) NSArray *appointmentArray;
@property (weak, nonatomic) IBOutlet UITableView *appointmentTableView;
@end
