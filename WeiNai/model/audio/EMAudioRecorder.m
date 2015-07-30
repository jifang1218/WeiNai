
#import "EMAudioRecorder.h"
@import AVFoundation;

static NSString *kWavExt = @"wav";

typedef void (^CBAudioRecordFinished)(NSString *recordPath);

@interface EMAudioRecorder () <AVAudioRecorderDelegate> {
    NSDate *_startDate;
    NSDate *_endDate;
    
    CBAudioRecordFinished _cbAudioRecordFinished;
}

@property (nonatomic, strong, nonnull) NSDictionary *recordSetting;

@end

@implementation EMAudioRecorder

@synthesize recorder = _recorder;
@synthesize recordSetting = _recordSetting;

#pragma mark - getter
- (NSDictionary *)recordSetting
{
    if (!_recordSetting) {
        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                          nil];
    }
    
    return _recordSetting;
}

#pragma mark - Private
- (void)dealloc{
    if (_recorder) {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
    _cbAudioRecordFinished = nil;
}

- (BOOL)isRecording{
    return _recorder.isRecording;
}

// 开始录音，文件放到aFilePath下
- (void)asyncStartRecordWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion {
    NSError *error = nil;
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension]
                             stringByAppendingPathExtension:kWavExt];
    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl
                                            settings:self.recordSetting
                                               error:&error];
    if(!_recorder || error) {
        _recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"Failed to initialize AVAudioRecorder")
                                        code:-1
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    _startDate = [NSDate date];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
    [_recorder record];
    if (completion) {
        completion(error);
    }
}

// 停止录音
- (void)asyncStopRecordWithCompletion:(void(^)(NSString *recordPath))completion {
    _cbAudioRecordFinished = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recorder stop];
    });
}

// 取消录音
- (void)cancelCurrentRecord {
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    _cbAudioRecordFinished = nil;
}


#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag {
    NSString *recordPath = [[_recorder url] path];
    if (_cbAudioRecordFinished) {
        if (!flag) {
            recordPath = nil;
        }
        _cbAudioRecordFinished(recordPath);
    }
    _recorder = nil;
    _cbAudioRecordFinished = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}
@end
