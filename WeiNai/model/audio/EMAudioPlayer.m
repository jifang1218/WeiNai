
#import "EMAudioPlayer.h"
@import AVFoundation;

typedef void (^CBAudioPlayFinished)(NSError *error);

@interface EMAudioPlayer () <AVAudioPlayerDelegate> {
    AVAudioPlayer *_player;
    CBAudioPlayFinished _cbAudioPlayFinished;
}

@end

@implementation EMAudioPlayer

#pragma mark - public

// 当前是否正在播放
- (BOOL)isPlaying {
    return _player.isPlaying;
}

// 得到当前播放音频路径
- (NSString *)playingFilePath {
    NSString *path = nil;
    
    NSURL *url = [self playingFileUrl];
    path = [url path];
    
    return path;
}

- (NSURL *)playingFileUrl {
    NSURL *path = nil;
    if (_player && _player.isPlaying) {
        path = _player.url;
    }
    
    return path;
}

- (void)asyncPlayWithPath:(NSString *)aFilePath
               completion:(void(^)(NSError *error))completon {
    _cbAudioPlayFinished = completon;
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:aFilePath]) {
        error = [NSError errorWithDomain:NSLocalizedString(@"error.notFound", @"File path not exist")
                                    code:-1
                                userInfo:nil];
        if (_cbAudioPlayFinished) {
            _cbAudioPlayFinished(error);
        }
        _cbAudioPlayFinished = nil;
        
        return;
    }
    
    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:aFilePath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:wavUrl
                                                     error:&error];
    if (error || !_player) {
        _player = nil;
        error = [NSError errorWithDomain:NSLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer")
                                    code:-1
                                userInfo:nil];
        if (_cbAudioPlayFinished) {
            _cbAudioPlayFinished(error);
        }
        _cbAudioPlayFinished = nil;
        return;
    }
    
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
}

// 停止当前播放
- (void)stopCurrentPlaying {
    if(_player){
        _player.delegate = nil;
        [_player stop];
        _player = nil;
    }
    if (_cbAudioPlayFinished) {
        _cbAudioPlayFinished = nil;
    }
}

- (void)dealloc {
    if (_player) {
        _player.delegate = nil;
        [_player stop];
        _player = nil;
    }
    _cbAudioPlayFinished = nil;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    if (_cbAudioPlayFinished) {
        NSError *error = nil;
        if (flag) {
            error =  [NSError errorWithDomain:@"error.playFailure"
                                         code:-1
                                     userInfo:nil];
        }
        _cbAudioPlayFinished(error);
    }
    
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
    _cbAudioPlayFinished = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error{
    if (_cbAudioPlayFinished) {
        _cbAudioPlayFinished(error);
    }
    
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
}

@end
