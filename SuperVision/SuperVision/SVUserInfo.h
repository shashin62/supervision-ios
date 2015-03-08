//
//  SVUserInfo.h
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAppoinmentinfo.h"

@interface SVUserInfo : NSObject

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * uId;
@property (nonatomic, strong) NSString * chavi;
@property (nonatomic, strong) NSString * appId;
@property (nonatomic, strong) NSMutableArray * appointmentArray;

-(id)initWithValues:(NSDictionary*)dict;
-(void)resetAllValues;
@end
