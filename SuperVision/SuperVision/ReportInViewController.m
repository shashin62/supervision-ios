//
//  ReportInViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "ReportInViewController.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "RecordingViewController.h"
#import "ChangeAddressViewController.h"
#import "ChangeEmployerAddressViewController.h"
#import "PaymentsViewController.h"
#import "AppDelegate.h"

#if TARGET_IPHONE_SIMULATOR
NSString * const DeviceMode = @"Simulator";
#else
NSString * const DeviceMode = @"Device";
#endif

@interface ReportInViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureSession* captureSession;
//@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIImage* cameraImage;

@property (nonatomic) BOOL isAddressChanged;
@property (nonatomic) BOOL isJobChanged;
@property (nonatomic) BOOL isArrestedChanged;
@property (nonatomic) BOOL isPaymentChanged;
@property (nonatomic) BOOL isScheduleAppointmentChanged;

@property (weak, nonatomic) IBOutlet UIButton *yesAddressChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noAddressChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesJobChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noJobChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesArrestedChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noArrestedChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesPaymentChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noPaymentChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesScheduleAppointmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *noScheduleAppointmentBtn;

-(IBAction)setAddressChangeYES:(id)sender;
-(IBAction)setAddressChangeNO:(id)sender;

-(IBAction)setJobChangeYES:(id)sender;
-(IBAction)setJobChangeNO:(id)sender;

-(IBAction)setArrestedChangeYES:(id)sender;
-(IBAction)setArrestedChangeNO:(id)sender;

-(IBAction)setScheduleAppointmentChangeYES:(id)sender;
-(IBAction)setScheduleAppointmentChangeNO:(id)sender;

-(IBAction)setPaymentChangeYES:(id)sender;
-(IBAction)setPaymentChangeNO:(id)sender;

-(IBAction)continueButtonActionEvent:(id)sender;
-(void)takeScreenShotAndSend;
@end

@implementation ReportInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.continueBtn.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    self.title = @"Report In";

    if([DeviceMode isEqualToString:@"Device"])
        [self takeScreenShotAndSend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Take Snapshot

- (void)takeScreenShotAndSend
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
    [self.captureSession setSessionPreset:AVCaptureSessionPresetLow];
    
//    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
//    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    
//    // CHECK FOR YOUR APP
//    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//    self.previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
    // CHECK FOR YOUR APP
    
    //    [self.view.layer insertSublayer:self.previewLayer atIndex:0];   // Comment-out to hide preview layer
    
    [self.captureSession startRunning];
    
    [self performSelector:@selector(sendSnapShot) withObject:nil afterDelay:1.0];
    
//    [self.captureSession stopRunning];
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
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    self.cameraImage = nil;
    self.cameraImage = [UIImage imageWithCGImage:newImage scale:1.0f orientation:UIImageOrientationLeft];
    CGImageRelease(newImage);
    
    
    
    
    
}

//- (void)setupTimer
//{
//    NSTimer* cameraTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(snapshot) userInfo:nil repeats:YES];
//}

- (void)snapshot
{
    NSLog(@"SNAPSHOT");
    // Comment-out to hide snapshot
}

- (void)sendSnapShot
{
    [self.captureSession stopRunning];
    
//    NSData *pngData = UIImagePNGRepresentation(self.cameraImage);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//    [pngData writeToFile:filePath atomically:YES]; //Write the file

    UIImage *rotatedImage = [self imageByRotatingImage:self.cameraImage fromImageOrientation:UIImageOrientationRight];

    
    
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    NSData *imageData = UIImagePNGRepresentation(rotatedImage);
    if(imageData){
        [networkApi uploadImage:imageData completionHandler:^(NSString *imageName, NSError *error) {
            NSLog(@"Image Upload Api Call");
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate.userInfoChangedRequestParam setObject:imageName forKey:@"CheckInPictureName"];
            
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    

}


-(UIImage*)imageByRotatingImage:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = initImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            return initImage;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    // Create the bitmap context
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    if (context == NULL)
        // error creating context
        return nil;
    
    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);
    
    CGContextConcatCTM(context, transform);
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);
    
    CGImageRef imgRef2 = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:initImage.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}

#pragma mark - Action Events

-(IBAction)setAddressChangeYES:(id)sender{
    self.isAddressChanged = YES;
    [self.yesAddressChangeBtn setSelected:YES];
    [self.noAddressChangeBtn setSelected:NO];
}
-(IBAction)setAddressChangeNO:(id)sender{
    self.isAddressChanged = NO;
    [self.yesAddressChangeBtn setSelected:NO];
    [self.noAddressChangeBtn setSelected:YES];

}

-(IBAction)setJobChangeYES:(id)sender{
    self.isJobChanged = YES;
    [self.yesJobChangeBtn setSelected:YES];
    [self.noJobChangeBtn setSelected:NO];
}
-(IBAction)setJobChangeNO:(id)sender{
    self.isJobChanged = NO;
    [self.yesJobChangeBtn setSelected:NO];
    [self.noJobChangeBtn setSelected:YES];
}

-(IBAction)setArrestedChangeYES:(id)sender{
    self.isArrestedChanged = YES;
    [self.yesArrestedChangeBtn setSelected:YES];
    [self.noArrestedChangeBtn setSelected:NO];
}
-(IBAction)setArrestedChangeNO:(id)sender{
    self.isArrestedChanged = NO;
    [self.yesArrestedChangeBtn setSelected:NO];
    [self.noArrestedChangeBtn setSelected:YES];
}

-(IBAction)setScheduleAppointmentChangeYES:(id)sender{
    self.isScheduleAppointmentChanged = YES;
    [self.yesScheduleAppointmentBtn setSelected:YES];
    [self.noScheduleAppointmentBtn setSelected:NO];
}
-(IBAction)setScheduleAppointmentChangeNO:(id)sender{
    self.isScheduleAppointmentChanged = NO;
    [self.yesScheduleAppointmentBtn setSelected:NO];
    [self.noScheduleAppointmentBtn setSelected:YES];
}

-(IBAction)setPaymentChangeYES:(id)sender{
    self.isPaymentChanged = YES;
    [self.yesPaymentChangeBtn setSelected:YES];
    [self.noPaymentChangeBtn setSelected:NO];
}
-(IBAction)setPaymentChangeNO:(id)sender{
    self.isPaymentChanged = NO;
    [self.yesPaymentChangeBtn setSelected:NO];
    [self.noPaymentChangeBtn setSelected:YES];
}

-(IBAction)continueButtonActionEvent:(id)sender{
    
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(self.isAddressChanged)
    [appDelegate.userInfoChangedRequestParam setObject:@"true" forKey:@"HasAddressChanged"];
    if(self.isJobChanged)
    [appDelegate.userInfoChangedRequestParam setObject:@"true" forKey:@"HasJobChanged"];
    if(self.isArrestedChanged)
    [appDelegate.userInfoChangedRequestParam setObject:@"true" forKey:@"hasArrested"];
    if(self.isPaymentChanged)
    [appDelegate.userInfoChangedRequestParam setObject:@"true" forKey:@"hasPayment"];
    if(self.isScheduleAppointmentChanged)
    [appDelegate.userInfoChangedRequestParam setObject:@"true" forKey:@"hasAppointmentWithOfficer"];

    
        if(self.isAddressChanged){
            ChangeAddressViewController *changeAddressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewControllerStoryBoardId"];
            changeAddressViewController.isJobChanged = self.isJobChanged;
            changeAddressViewController.isPaymentChanged = self.isPaymentChanged;
            [self.navigationController pushViewController:changeAddressViewController animated:YES];

        }else if(self.isJobChanged){
            ChangeEmployerAddressViewController *changeEmployerAddressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeEmployerAddressViewControllerStoryBoardId"];
            changeEmployerAddressViewController.isPaymentChanged = self.isPaymentChanged;
            [self.navigationController pushViewController:changeEmployerAddressViewController animated:YES];
        }else if(self.isPaymentChanged)
        {
            PaymentsViewController *paymentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentsViewControllerStoryBoardId"];
            [self.navigationController pushViewController:paymentsViewController animated:YES];
        }else{
            RecordingViewController *recordingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingViewControllerStoryBoardId"];
            [self.navigationController pushViewController:recordingViewController animated:YES];
        }
}

-(void)dealloc{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.userInfoChangedRequestParam removeAllObjects];
}


@end
