//
//  SVLoginRequest.m
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import "SVLoginRequest.h"

@interface SVLoginRequest ()


@end

@implementation SVLoginRequest

-(id)initWithUserName:(NSString*)userName password:(NSString*)password{
    self = [super init];
    if(self)
    {
        self.userName = userName;
        self.password = password;
    }
    return self;
}
@end
