//
//  AppointmentTableViewCell.h
//  SuperVision
//
//  Created by Sachin Soni on 05/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *appointmentName;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTime;

@end
