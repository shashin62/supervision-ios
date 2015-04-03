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

@interface SVNetworkApi ()
- (NSMutableDictionary*)getCheckindDictionary:(NSMutableDictionary*)dic;
@end

@implementation SVNetworkApi

-(void) loginWithCompletionBlock :(SVLoginRequest*)body completionHandler: (void (^)(SVLoginResponse* output, NSError* error))completionBlock{
    
    NSString *loginApiUrl = [NSString stringWithFormat:kLoginUrl,[body userName],[body password]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:loginApiUrl]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
  
    if (data) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            completionBlock(nil, connectionError);
            return;
        }
        
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
            
            id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                completionBlock(nil, error);
                return;
            }
            
            NSArray* resultsArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//            NSLog(@"jsonReturn %@",resultsArray);
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
   // NSString *postdataString = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postdata];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Mobile Check In  response:%@ \nData:%@ \nerror:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
        if(data){
            NSString *IsSuccessStatusCodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange range = [IsSuccessStatusCodeString rangeOfString:@"true"];
            if(range.location != NSNotFound){
                completionBlock(@"true", nil);
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
    if ([[path pathExtension] isEqualToString:@"caf"]) {
        return @"audio/x-caf";
    }
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

- (NSMutableDictionary*)getCheckindDictionary:(NSMutableDictionary*)dic{
    NSMutableDictionary *checkinDetailDictionary = [[NSMutableDictionary alloc] init];
        [checkinDetailDictionary setObject:([dic objectForKey:@"title" ] ? [dic objectForKey:@"title" ]: @" ") forKey:@"title"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"description" ] ? [dic objectForKey:@"description" ]: @" ") forKey:@"description"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"lat" ] ? [dic objectForKey:@"lat" ]: @" ") forKey:@"lat"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"lng" ] ? [dic objectForKey:@"lng" ]: @" ") forKey:@"lng"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"PaymentSource" ] ? [dic objectForKey:@"PaymentSource" ]: @" ") forKey:@"PaymentSource"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficeZip" ] ? [dic objectForKey:@"OfficeZip" ]: @" ") forKey:@"OfficeZip"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"CheckInAudioRecordingPath" ] ? [dic objectForKey:@"CheckInAudioRecordingPath" ]: @" ") forKey:@"CheckInAudioRecordingPath"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"CheckInDate" ] ? [dic objectForKey:@"CheckInDate" ]: @" ") forKey:@"CheckInDate"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficeState" ] ? [dic objectForKey:@"OfficeState" ]: @" ") forKey:@"OfficeState"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"CheckInPictureName" ] ? [dic objectForKey:@"CheckInPictureName" ]: @" ") forKey:@"CheckInPictureName"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"CompanyName" ] ? [dic objectForKey:@"CompanyName" ]: @" ") forKey:@"CompanyName"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficePhone" ] ? [dic objectForKey:@"OfficePhone" ]: @" ") forKey:@"OfficePhone"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficeCity" ] ? [dic objectForKey:@"OfficeCity" ]: @" ") forKey:@"OfficeCity"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomeAddress1" ] ? [dic objectForKey:@"HomeAddress1" ]: @" ") forKey:@"HomeAddress1"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomeAddress2" ] ? [dic objectForKey:@"HomeAddress2" ]: @" ") forKey:@"HomeAddress2"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomeCity" ] ? [dic objectForKey:@"HomeCity" ]: @" ") forKey:@"HomeCity"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomePhone" ] ? [dic objectForKey:@"HomePhone" ]: @" ") forKey:@"HomePhone"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomeState" ] ? [dic objectForKey:@"HomeState" ]: @" ") forKey:@"HomeState"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HomeZip" ] ? [dic objectForKey:@"HomeZip" ]: @" ") forKey:@"HomeZip"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficeAddress1" ] ? [dic objectForKey:@"OfficeAddress1" ]: @" ") forKey:@"OfficeAddress1"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"OfficeAddress2" ] ? [dic objectForKey:@"OfficeAddress2" ]: @" ") forKey:@"OfficeAddress2"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HasJobChanged" ] ? [dic objectForKey:@"HasJobChanged" ]: @" ") forKey:@"HasJobChanged"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"HasAddressChanged" ] ? [dic objectForKey:@"HasAddressChanged" ]: @" ") forKey:@"HasAddressChanged"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"CheckInID" ] ? [dic objectForKey:@"CheckInID" ]: @" ") forKey:@"CheckInID"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"hasArrested" ] ? [dic objectForKey:@"hasArrested" ]: @" ") forKey:@"hasArrested"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"hasPayment" ] ? [dic objectForKey:@"hasPayment" ]: @" ") forKey:@"hasPayment"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"PaymentAmount" ] ? [dic objectForKey:@"PaymentAmount" ]: @" ") forKey:@"PaymentAmount"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"hasAppointmentWithOfficer" ] ? [dic objectForKey:@"hasAppointmentWithOfficer" ]: @" ") forKey:@"hasAppointmentWithOfficer"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"AppointmentID" ] ? [dic objectForKey:@"AppointmentID" ]: @" ") forKey:@"AppointmentID"];
        [checkinDetailDictionary setObject:([dic objectForKey:@"UserID" ] ? [dic objectForKey:@"UserID" ]: @" ") forKey:@"UserID"];
    return checkinDetailDictionary;
}
@end
