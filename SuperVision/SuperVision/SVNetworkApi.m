//
//  SVNetworkApi.m
//  SuperVision
//
//  Created by Sachin Soni on 04/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "SVNetworkApi.h"
#import "SVLoginRequest.h"
#import "SVLoginResponse.h"
#import "SVConstant.h"
#import "SVAppoinmentinfo.h"

@implementation SVNetworkApi

-(void) loginWithCompletionBlock :(SVLoginRequest*)body completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock{
    
    NSString *loginApiUrl = [NSString stringWithFormat:kLoginUrl,[body userName],[body password]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:loginApiUrl]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    NSError *error;
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"aData=%@",aData);
    if (aData) {
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"jsonReturn %@",results);
        if(results){
            SVLoginResponse *loginResponse = [[SVLoginResponse alloc] initWithValues:results];
            completionBlock(loginResponse, nil);
        }
    }else
            completionBlock(nil, error);
    
}

-(void) getAppoinmentList:(NSString*)uId completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock{
    
    NSString *appoitmentApiUrl = [NSString stringWithFormat:kAppointmentUrl,uId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:appoitmentApiUrl]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    NSError *error;
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"aData=%@",aData);
    if (aData) {
        NSArray* resultsArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"jsonReturn %@",resultsArray);
        if(resultsArray){
            
          completionBlock([self getAppointmentObjectArrayFromData:resultsArray], nil);
        }
    }else
        completionBlock(nil, error);
}

-(void)uploadImage:(NSData *)imageData completionHandler:(void (^)(NSString *, NSError *))completionBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kPictureUploadUrl]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"unique-consistent-string";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"imgUpload response:%@ \nData:%@ \nerror:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
        if(response){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSDictionary* results = [httpResponse allHeaderFields];
        NSLog(@"Image Name is %@",results[@"ImageName"]);
            completionBlock(results[@"ImageName"], nil);
        }
    else
            completionBlock(nil, error);
    }];
}


-(void)uploadAudio:(NSData *)audioData completionHandler:(void (^)(NSString *, NSError *))completionBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kPictureUploadUrl]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"unique-consistent-string";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (audioData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:audioData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"AudioUpload  response:%@ \nData:%@ \nerror:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
        if(response){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSDictionary* results = [httpResponse allHeaderFields];
            NSLog(@"Image Name is %@",results[@"AudioName"]);
            completionBlock(results[@"AudioName"], nil);
        }
        else
            completionBlock(nil, error);
    }];
}

-(NSArray*)getAppointmentObjectArrayFromData:(NSArray*)array{
    NSMutableArray *appointmentArray = [[NSMutableArray alloc] init];
    for (NSDictionary *appointmentInfoObject in array) {
        
        SVAppoinmentinfo *appointmentInfo = [[SVAppoinmentinfo alloc] init];
        
        if(appointmentInfoObject[@"AppointmentTypes"]){
        NSDictionary *appointmentTypeDic = appointmentInfoObject[@"AppointmentTypes"];
        [appointmentInfo setAppointmentName:appointmentTypeDic[@"AppointmentName"]];
        }
        
        if(appointmentInfoObject[@"Officer"]){
        NSDictionary *officerDic = appointmentInfoObject[@"Officer"];
        [appointmentInfo setAppointmentOfficer:officerDic[@"AppoinmentWith"]];
        }
        
        if(appointmentInfoObject[@"Status"])
        [appointmentInfo setAppointmentStatus:appointmentInfoObject[@"Status"]];
        
        if(appointmentInfoObject[@"AppointmentDate"])
        [appointmentInfo setAppointmentCreateDate:appointmentInfoObject[@"AppointmentDate"]];
        
        [appointmentArray addObject:appointmentInfo];
    }
    return appointmentArray;
}

@end
