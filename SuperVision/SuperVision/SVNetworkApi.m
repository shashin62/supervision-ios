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
#import <MobileCoreServices/MobileCoreServices.h>

@implementation SVNetworkApi

-(void) loginWithCompletionBlock :(SVLoginRequest*)body completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock{
    
    NSString *loginApiUrl = [NSString stringWithFormat:kLoginUrl,[body userName],[body password]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:loginApiUrl]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
   // NSLog(@"aData=%@",aData);
    if (data) {
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"jsonReturn %@",results);
        if(results){
            SVLoginResponse *loginResponse = [[SVLoginResponse alloc] initWithValues:results];
            completionBlock(loginResponse, nil);
        }
        
    }else
            completionBlock(nil, connectionError);
    }];
}

-(void) getAppoinmentList:(NSString*)uId completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock{
    
    NSString *appoitmentApiUrl = [NSString stringWithFormat:kAppointmentUrl,uId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:appoitmentApiUrl]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data) {
            NSArray* resultsArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"jsonReturn %@",resultsArray);
            if(resultsArray){
                completionBlock([self getAppointmentObjectArrayFromData:resultsArray], nil);
            }
        }else
            completionBlock(nil, error);
    }];
   // NSLog(@"aData=%@",aData);
    
}

-(void)doMobileCheckIn:(NSMutableDictionary*)params completionHandler:(void (^)(NSString* response, NSError* error))completionBlock{
    
    NSURL *url = [NSURL URLWithString:kManageCheckinUrl];
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postdata];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Mobile Check In  response:%@ \nData:%@ \nerror:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
        if(data){
            NSString *IsSuccessStatusCodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *responseArray = [IsSuccessStatusCodeString componentsSeparatedByString:@"="];
            if(responseArray && [responseArray count] >1){
                NSString *statusString = [responseArray objectAtIndex:1];
                completionBlock(statusString, nil);
            }else
                completionBlock(@"false", nil);

        }
        else
            completionBlock(nil, error);
    }];
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


-(void)uploadAudio:(NSString *)audioFilePath completionHandler:(void (^)(NSString *, NSError *))completionBlock{
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kAudioUrl]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"unique-consistent-string";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createAudioBodyWithBoundary:boundary parameters:nil paths:@[audioFilePath] fieldName:nil];
    [request setHTTPBody:httpBody];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Audio upload response:%@ \nData:%@ \nerror:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
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

- (NSData *)createAudioBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  =  [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}
- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}
@end
