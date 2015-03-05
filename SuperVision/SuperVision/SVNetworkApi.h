//
//  SVNetworkApi.h
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVLoginRequest.h"
#import "SVLoginResponse.h"


@interface SVNetworkApi : NSObject


-(void) loginWithCompletionBlock :(SVLoginRequest*)body completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock;
-(void) getAppoinmentList:(NSString*)uId completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock;
-(void) uploadImage:(NSData*)imageData completionHandler: (void (^)(NSString* imageName, NSError* error))completionBlock;
//-(void) uploadAudio:(NSData*)audioData completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock;
// -(void) manageCheckin
@end
