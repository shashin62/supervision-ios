//
//  RecordingViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 Ashish ojha. All rights reserved.
//

#import "RecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckinVerfiedViewController.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"



#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingViewController () <AVAudioRecorderDelegate>
{
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
    NSString *mp3AudioFilePath;
    AVAudioRecorder *recorder;
    SystemSoundID soundID;

}
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordTextMessage;
@property (weak, nonatomic) IBOutlet UILabel *recordingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation RecordingViewController

//@"Recording Started"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topView.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.btnRecord.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    [self.recordingLabel setHidden:YES];
    recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    recorderFilePath = [NSString stringWithFormat:@"%@/recordedSound.caf", DOCUMENTS_FOLDER];
    mp3AudioFilePath = [NSString stringWithFormat:@"%@/recordedSound.mp3", DOCUMENTS_FOLDER];
    [self.btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord setTitle:@"Start Recording" forState:UIControlStateNormal];

    AppDelegate *appDelegateObject = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if(appDelegateObject.userInfo.audioRecordMessage)
        [self.lblRecordTextMessage setText:appDelegateObject.userInfo.audioRecordMessage];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicatorView stopAnimating];
    [self.recordingLabel setHidden:YES];
    [self.btnRecord setTitle:@"Start Recording" forState:UIControlStateNormal];
    [self.btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)startRecording:(id)sender{
    
    if(recorder!=nil){
        recorder=nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    NSLog(@"recorderFilePath: %@",recorderFilePath);
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    [self.recordingLabel setHidden:NO];
    [self.activityIndicatorView startAnimating];
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 20];
    [self.btnRecord setTitle:@"Stop Recording" forState:UIControlStateNormal];
    [self.btnRecord removeTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) stopRecording:(id)sender
{
    [self.activityIndicatorView stopAnimating];
    [self.recordingLabel setHidden:YES];
    [recorder stop];
    NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(!audioData){
        NSLog(@"NO audio data Found: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
    }else{
    NSError * err1 = NULL;
    NSFileManager * fm1 = [[NSFileManager alloc] init];
    [fm1 removeItemAtPath:mp3AudioFilePath error:&err];
    BOOL result = [fm1 moveItemAtPath:recorderFilePath toPath:mp3AudioFilePath error:&err1];
    if(!result)
        NSLog(@"Error: %@", err);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    [networkApi uploadAudio:mp3AudioFilePath completionHandler:^(NSString *audioName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.btnRecord setTitle:@"Start Recording" forState:UIControlStateNormal];
            [self.btnRecord removeTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
        });
        if (error) {
            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [message show];
        }else if(audioName.length)
       {
           AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
           [appDelegate.userInfoChangedRequestParam setObject:audioName forKey:@"CheckInAudioRecordingPath"];
           CheckinVerfiedViewController *checkinVerfiedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVerfiedViewControllerStoryBoardId"];
           [self.navigationController pushViewController:checkinVerfiedViewController animated:YES];
       }
    }];
  }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
