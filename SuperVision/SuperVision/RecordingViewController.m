//
//  RecordingViewController.m
//  SuperVision
//
//  Created by Sachin Soni on 06/03/15.
//  Copyright (c) 2015 SuperVision. All rights reserved.
//

#import "RecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckinVerfiedViewController.h"
#import "SVNetworkApi.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>




#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingViewController () <AVAudioRecorderDelegate>
{
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
//    NSString *mp3AudioFilePath;
    AVAudioRecorder *recorder;
    SystemSoundID soundID;
    AVAudioSession *audioSession ;

}
//@property (nonatomic) TPAACAudioConverter *audioConverter;
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
    
    
    
    recorderFilePath = [NSString stringWithFormat:@"%@/audio.m4a", DOCUMENTS_FOLDER];
//    mp3AudioFilePath = [NSString stringWithFormat:@"%@/audio.m4a", DOCUMENTS_FOLDER];
    
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


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
//    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
    
}

-(IBAction)startRecording:(id)sender{
    
    if(recorder!=nil){
        recorder=nil;
    }
    
     audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    if(err){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recording audio", @"")
                                    message:NSLocalizedString(@"Couldn't record audio: Not supported on this device", @"")
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        return;
    }
    
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recording audio", @"")
                                    message:NSLocalizedString(@"Couldn't record audio: Not supported on this device", @"")
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        return;
    }
    
//    NSLog(@"recorderFilePath: %@",recorderFilePath);
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
//        [fm removeItemAtPath:mp3AudioFilePath error:&err];
    }
    err = nil;
    
    recordSetting = [[NSMutableDictionary alloc] init];
//    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//    
//    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    [recordSetting setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSetting setObject:[NSNumber numberWithFloat:16000.0] forKey: AVSampleRateKey];
    [recordSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//    [recordSetting setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
//    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setObject:[NSNumber numberWithInt: AVAudioQualityMedium] forKey: AVEncoderAudioQualityKey];
    
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
//        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
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
//    [recorder prepareToRecord];
    
    if(![recorder prepareToRecord]){
        //        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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
//   [recorder recordForDuration:(NSTimeInterval) 20];
    [recorder record];
    [self.btnRecord setTitle:@"Stop Recording" forState:UIControlStateNormal];
    [self.btnRecord removeTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) stopRecording:(id)sender
{
    [self.activityIndicatorView stopAnimating];
    [self.recordingLabel setHidden:YES];
    [recorder stop];
    
    int flags = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
    [audioSession setActive:NO withOptions:flags error:nil];
    recorder = nil;
    audioSession = nil;
    
    
//  [self convert];
    
    
    
    
    
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
    [networkApi uploadAudio:recorderFilePath completionHandler:^(NSString *audioName, NSError *error) {
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
            dispatch_async(dispatch_get_main_queue(), ^{
                CheckinVerfiedViewController *checkinVerfiedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVerfiedViewControllerStoryBoardId"];
                [self.navigationController pushViewController:checkinVerfiedViewController animated:YES];
            });
        }
    }];
    
}

//
//- (void)convert {
//    if ( ![TPAACAudioConverter AACConverterAvailable] ) {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
//                                    message:NSLocalizedString(@"Couldn't convert audio: Not supported on this device", @"")
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
//        return;
//    }
//    
//    // Register an Audio Session interruption listener, important for AAC conversion
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(audioSessionInterrupted:)
//                                                 name:AVAudioSessionInterruptionNotification
//                                               object:nil];
//    
//    // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
//    NSError *error = nil;
//    if ( ![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
//                                           withOptions:0
//                                                 error:&error] ) {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
//                                    message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't setup audio category: %@", @""), error.localizedDescription]
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        return;
//    }
//    
//    // Activate audio session
//    if ( ![[AVAudioSession sharedInstance] setActive:YES error:NULL] ) {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
//                                    message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't activate audio category: %@", @""), error.localizedDescription]
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        return;
//        
//    }
//    
//    self.audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self
//                                                                 source:recorderFilePath
//                                                            destination:mp3AudioFilePath];
//
//    [_audioConverter start];
//}

#pragma mark - Audio converter delegate

//-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
////    self.progressView.progress = progress;
//}
//
//-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {
//    
////    [self.spinner stopAnimating];
//    
//    self.audioConverter = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    SVNetworkApi *networkApi = [[SVNetworkApi alloc] init];
//    [networkApi uploadAudio:mp3AudioFilePath completionHandler:^(NSString *audioName, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.btnRecord setTitle:@"Start Recording" forState:UIControlStateNormal];
//            [self.btnRecord removeTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
//            [self.btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
//        });
//        if (error) {
//            UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//            [message show];
//        }else if(audioName.length)
//        {
//            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [appDelegate.userInfoChangedRequestParam setObject:audioName forKey:@"CheckInAudioRecordingPath"];
//            CheckinVerfiedViewController *checkinVerfiedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVerfiedViewControllerStoryBoardId"];
//            [self.navigationController pushViewController:checkinVerfiedViewController animated:YES];
//        }
//    }];
//    
//}
//
//-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
//    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
//                                message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't convert audio: %@", @""), [error localizedDescription]]
//                               delegate:nil
//                      cancelButtonTitle:nil
//                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
//   
//    self.audioConverter = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - Audio session interruption

//- (void)audioSessionInterrupted:(NSNotification*)notification {
//    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
//    
//    if ( type == AVAudioSessionInterruptionTypeEnded) {
//        [[AVAudioSession sharedInstance] setActive:YES error:NULL];
//        if ( _audioConverter ) [_audioConverter resume];
//    } else if ( type == AVAudioSessionInterruptionTypeBegan ) {
//        if ( _audioConverter ) [_audioConverter interrupt];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
