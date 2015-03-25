//
//  SVLoginRequest.h
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVLoginRequest : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

-(id)initWithUserName:(NSString*)userName password:(NSString*)password;

@end
