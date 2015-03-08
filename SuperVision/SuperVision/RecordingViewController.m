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

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingViewController () <AVAudioRecorderDelegate>
{
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    SystemSoundID soundID;

}
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topView.backgroundColor = [UIColor colorWithRed:0.04 green:0.16 blue:0.35 alpha:1];
    self.btnRecord.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.2 alpha:1];
    recordSetting = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                     //  [NSNumber numberWithFloat: 16000.0],AVSampleRateKey,
                     [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,// kAudioFormatLinearPCM
                     //[NSNumber numberWithInt:kAudioFormatMPEGLayer3],AVFormatIDKey,
                     [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                     [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                     [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                     [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                     [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,nil];
    
    recorderFilePath = [NSString stringWithFormat:@"%@/recordedSound.wav", DOCUMENTS_FOLDER];
    [self.btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord setTitle:@"Start Recording" forState:UIControlStateNormal];
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
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
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
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 20];
        [self.btnRecord setTitle:@"Stop Recording" forState:UIControlStateNormal];
    [self.btnRecord removeTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) stopRecording:(id)sender
{
    NSLog(@"Stop Recording");
    [recorder stop];
    CheckinVerfiedViewController *checkinVerfiedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVerfiedViewControllerStoryBoardId"];
    [self.navigationController pushViewController:checkinVerfiedViewController animated:YES];

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
