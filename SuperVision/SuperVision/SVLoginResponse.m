//
//  SVLoginResponse.m
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "SVLoginResponse.h"

@interface SVLoginResponse ()

@end

@implementation SVLoginResponse

-(id)initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        self.uId = dict[@"uid"];
        self.chavi = dict[@"chavi"];
        self.appId = dict[@"appid"];
        self.audioTextReadMessage = dict[@"AudioReadText"];
    }
    return self;
}

@end
