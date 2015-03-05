//
//  LoginViewViewController.m
//  SuperVision
//
//  Created by Ashish ojha on 28/02/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "LoginViewViewController.h"
#import "DashboardViewController.h"
#import "SVLoginRequest.h"
#import "SVLoginResponse.h"
#import "SVUserInfo.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_IPHONE_SIMULATOR
NSString * const DeviceMode = @"Simulator";
#else
NSString * const DeviceMode = @"Device";
#endif

@interface LoginViewViewController ()<UITextFieldDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureSession* captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIImage* cameraImage;
@end

@implementation LoginViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.15 blue:0.33 alpha:1];
    
    self.loginBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.14 blue:0.2 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.usernameTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else if (textField == self.passwordTxt) {
        [self loginActionEvent:nil];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)loginActionEvent:(id)sender{
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    SVLoginRequest *loginRequest = [[SVLoginRequest alloc] initWithUserName:self.usernameTxt.text password:self.passwordTxt.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [networkApi loginWithCompletionBlock:loginRequest completionHandler:^(SVLoginResponse *output, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [message show];
        }else{
            
            if([DeviceMode isEqualToString:@"Device"])
                [self takeAndSendSnapshot];
            else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                DashboardViewController *dashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewControllerStoryBoardId"];
                [self.navigationController pushViewController:dashboardViewController animated:YES];
                });
            }
        }
    }];
    
}

-(void)takeAndSendSnapshot{
    [self setupCamera];
    DashboardViewController *dashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewControllerStoryBoardId"];
    [self.navigationController pushViewController:dashboardViewController animated:YES];
}

#pragma mark - Take Snapshot

- (void)setupCamera
{
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *device in devices)
    {
        if([device position] == AVCaptureDevicePositionFront)
            self.device = device;
    }
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    output.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString *) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [output setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:output];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // CHECK FOR YOUR APP
    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
    // CHECK FOR YOUR APP
    
    //    [self.view.layer insertSublayer:self.previewLayer atIndex:0];   // Comment-out to hide preview layer
    
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    self.cameraImage = [UIImage imageWithCGImage:newImage scale:1.0f orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease(newImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}
//
//- (void)setupTimer
//{
//    NSTimer* cameraTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(snapshot) userInfo:nil repeats:YES];
//}

- (void)snapshot
{
    NSLog(@"SNAPSHOT");
      // Comment-out to hide snapshot
}

@end
