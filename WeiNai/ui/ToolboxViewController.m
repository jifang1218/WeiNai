//
//  ToolboxViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ToolboxViewController.h"
#import "Toolbox.h"
@import AVFoundation;

@interface ToolboxViewController()<UITableViewDataSource, UITableViewDelegate,
                                   ToolboxDelegate,
                                   AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    UITableView *_tableview;
    Toolbox *_toolbox;
    AVAudioPlayer *_player;
    AVAudioRecorder *_recorder;
    UIButton *_playButton;
}

- (void)setupUI;
- (UITableViewCell *)configurePissCellForIndex:(NSInteger)index;
- (void)playPissSound:(id)sender;
- (void)recordPissSound:(id)sender;

@end

@implementation ToolboxViewController

- (id)init {
    if (self=[super init]) {
        _toolbox = [[Toolbox alloc] init];
        _toolbox.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _toolbox.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navigationController.tabBarItem.title;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

#pragma mark - helpers
- (void)setupUI {
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
}

- (UITableViewCell *)configurePissCellForIndex:(NSInteger)index {
    UITableViewCell *cell = nil;
    static NSString *identifier = @"ToolboxCell_Piss";
    cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // play button
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playBtn setTitle:@"播放"
             forState:UIControlStateNormal];
    [playBtn addTarget:self
                action:@selector(playPissSound:)
      forControlEvents:UIControlEventTouchUpInside];
    [playBtn sizeToFit];
    CGRect frame = playBtn.frame;
    frame.origin.y = (cell.contentView.frame.size.height - frame.size.height) / 2.0;
    frame.origin.x = 10;
    playBtn.frame = frame;
    [playBtn setEnabled:[_toolbox isPissAvailable]];
    [cell.contentView addSubview:playBtn];
    _playButton = playBtn;
    
    // record button
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [recordBtn setTitle:@"录制"
               forState:UIControlStateNormal];
    [recordBtn addTarget:self
                  action:@selector(recordPissSound:)
        forControlEvents:UIControlEventTouchUpInside];
    [recordBtn sizeToFit];
    cell.accessoryView = recordBtn;
    
    return cell;
}

#pragma mark - actions
- (void)playPissSound:(id)sender {
    NSURL *pissUrl = [_toolbox pissSoundURL];
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:pissUrl
                                                     error:&error];
    if (error) {
        NSLog(@"failed to play piss, error:%@", error);
        return;
    }
    _player.delegate = self;
    [_player play];
    [_playButton setEnabled:NO];
}

- (void)recordPissSound:(id)sender {
    NSURL *pissUrl = [_toolbox pissSoundURL];
    NSError *error = nil;
    NSDictionary *settingsDict = @{AVSampleRateKey:[NSNumber numberWithFloat:8000.0], // 采样率
                                   AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatLinearPCM],
                                   AVLinearPCMBitDepthKey:[NSNumber numberWithInt:16], // 采样位数 默认 16
                                   AVNumberOfChannelsKey:[NSNumber numberWithInt:1]};
    _recorder = [[AVAudioRecorder alloc] initWithURL:pissUrl
                                            settings:settingsDict
                                               error:&error];
    if (error) {
        NSLog(@"failed to record piss, error:%@", error);
        return;
    }
    _recorder.delegate = self;
    [_recorder recordForDuration:15.0];
    [_playButton setEnabled:NO];
}

#pragma mark - audio player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playButton setEnabled:YES];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [_playButton setEnabled:YES];
}

#pragma mark - audio recorder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (!flag) {
        [_playButton setEnabled:[_toolbox isPissAvailable]];
    } else {
        [_playButton setEnabled:YES];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [_playButton setEnabled:[_toolbox isPissAvailable]];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 0;
    switch (section) {
        case 0: {
            ret = 1;
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *ret = nil;
    
    switch (section) {
        case 0: {
            ret = @"催尿声音";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0: {
            cell = [self configurePissCellForIndex:row];
        } break;
        default: {
        } break;
    }
    
    return cell;
}

@end
