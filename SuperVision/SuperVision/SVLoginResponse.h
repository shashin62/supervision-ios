//
//  SVLoginResponse.h
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVLoginResponse : NSObject

@property (nonatomic, strong) NSString *uId;
@property (nonatomic, strong) NSString *chavi;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *audioTextReadMessage;

-(id)initWithValues:(NSDictionary*)dict;

@end
