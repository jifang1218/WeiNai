
#import <Foundation/Foundation.h>

@interface EMAudioPlayer : NSObject

// 当前是否正在播放
- (BOOL)isPlaying;

// 得到当前播放音频路径
- (NSString *)playingFilePath;
- (NSURL *)playingFileUrl;

// 播放指定路径下音频（wav）
- (void)asyncPlayWithPath:(NSString *)aFilePath
               completion:(void(^)(NSError *error))completon;

// 停止当前播放音频
- (void)stopCurrentPlaying;

@end
