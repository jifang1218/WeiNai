
#import <Foundation/Foundation.h>

@class AVAudioRecorder;

@interface EMAudioRecorder : NSObject

// 当前是否正在录音
- (BOOL)isRecording;

// 开始录音
- (void)asyncStartRecordWithPreparePath:(NSString *)aFilePath
                             completion:(void(^)(NSError *error))completion;

// 开始录固定时长录音
- (void)asyncStartRecordWithPreparePath:(NSString *)aFilePath
                      recordForDuration:(NSTimeInterval)duration
                             completion:(void(^)(NSString *recordPath, NSError *error))completion;
// 停止录音
- (void)asyncStopRecordWithCompletion:(void(^)(NSString *recordPath, NSError *error))completion;

// 取消录音
- (void)cancelCurrentRecord;

// current recorder
@property(nonatomic, strong, readonly) AVAudioRecorder *recorder;

@end
