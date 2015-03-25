//
//  SVUserInfo.m
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "SVUserInfo.h"

@implementation SVUserInfo

-(id)initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        self.appointmentArray = [[NSMutableArray alloc] init];
        self.uId = @"";
        self.chavi = @"";
        self.audioRecordMessage = @"";
    }
    return self;
}

-(void)resetAllValues
{
    [self.appointmentArray removeAllObjects];
    self.uId = @"";
    self.chavi = @"";
}

@end
