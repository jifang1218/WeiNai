//
//  ToolboxViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ToolboxViewController.h"
#import "Toolbox.h"
#import "Utility.h"
#import "EMAudioPlayer.h"
#import "EMAudioRecorder.h"
@import AVFoundation;


@interface ToolboxViewController()<UITableViewDataSource, UITableViewDelegate,
                                   ToolboxDelegate,
                                   AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    UITableView *_tableview;
    Toolbox *_toolbox;
    AVAudioPlayer *_player;
    AVAudioRecorder *_recorder;
    EMAudioRecorder *_audioRecorder;
    EMAudioPlayer *_audioPlayer;
    UIButton *_playButton;
    UILabel *_pissAvailableHint;
}
@property (nonatomic, strong) EMAudioPlayer *audioPlayer;
@property (nonatomic, strong) EMAudioRecorder *audioRecorder;

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
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
    [cell.contentView addSubview:playBtn];
    _playButton = playBtn;
    
    BOOL isPissAvailable = [_toolbox isPissAvailable];
    [playBtn setEnabled:isPissAvailable];
    UILabel *labelIsPissReadyText = [[UILabel alloc] init];
    if (isPissAvailable) {
        labelIsPissReadyText.text = [[NSString alloc] initWithFormat:@"上次录制于 : %@",
                                     [Utility compactDateComponentsString:[_toolbox lastPissRecordDate]]];
    } else {
        labelIsPissReadyText.text = @"尚未录制";
    }
    [labelIsPissReadyText sizeToFit];
    labelIsPissReadyText.center = cell.contentView.center;
    [cell.contentView addSubview:labelIsPissReadyText];
    _pissAvailableHint = labelIsPissReadyText;
    
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
    [_playButton setEnabled:NO];
    NSString *pissPath = [_toolbox pissSoundPath];
    [self.audioPlayer asyncPlayWithPath:pissPath
                             completion:^(NSError *error)
    {
        [_playButton setEnabled:YES];
        if (!error) {
            _pissAvailableHint.text = [[NSString alloc] initWithFormat:@"上次录制于 : %@",
                                       [Utility compactDateComponentsString:[_toolbox lastPissRecordDate]]];
            [_pissAvailableHint sizeToFit];
        }else {
            NSLog(@"failed to play piss, error:%@", error);
            return;
        }
    }];
}

- (void)recordPissSound:(id)sender {
    NSString *pissPath = [_toolbox pissSoundPath];
    [_playButton setEnabled:NO];
    [self.audioRecorder asyncStartRecordWithPreparePath:pissPath
                                      recordForDuration:15.0
                                             completion:^(NSString *recordPath, NSError *error)
     {
        if (!error) {
            [_playButton setEnabled:YES];
            _pissAvailableHint.text = [[NSString alloc] initWithFormat:@"上次录制于 : %@",
                                       [Utility compactDateComponentsString:[_toolbox lastPissRecordDate]]];
            [_pissAvailableHint sizeToFit];
        }else {
            [_playButton setEnabled:[_toolbox isPissAvailable]];
        }
    }];
}


#pragma mark - getter
-(EMAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[EMAudioPlayer alloc] init];
    }
    
    return _audioPlayer;
}

-(EMAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        _audioRecorder = [[EMAudioRecorder alloc] init];
        [_audioRecorder.recorder recordForDuration:15.0];
    }
    
    return _audioRecorder;
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
