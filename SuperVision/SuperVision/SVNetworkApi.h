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
-(void) getAppoinmentList:(NSString*)uId completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock;
-(void) uploadImage:(NSData*)imageData completionHandler: (void (^)(NSString* imageName, NSError* error))completionBlock;
-(void)uploadAudio:(NSString *)audioFilePath completionHandler:(void (^)(NSString *audioName, NSError *error))completionBlock;
-(void)doMobileCheckIn:(NSMutableDictionary*)params completionHandler:(void (^)(NSString* response, NSError* error))completionBlock;
@end
