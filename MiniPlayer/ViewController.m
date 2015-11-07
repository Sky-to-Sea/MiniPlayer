//
//  ViewController.m
//  MiniPlayer
//
//  Created by Earth on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "ViewController.h"
#import "PlayList.h"
#import "MPSlider.h"

#import "BackgourdView.h"

@interface ViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) PlayList *playList;

@property (nonatomic, strong) BackgourdView *backView;
@property (nonatomic, strong) MPSlider *soundSlider;
@property (nonatomic, strong) MPSlider *playSlider;
@property (nonatomic, strong) BackgourdView *playPanel;
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *aboveButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playList = [[PlayList alloc]init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onExpired) userInfo:nil repeats:YES];
    //_player.delegate = self;
    
    // 背景图片
    _backView = [[BackgourdView alloc]initWithFrame:ScreamFrame];
    _backView.image = [UIImage imageNamed:@"homePage_default"];
    [self.view addSubview:_backView];
    
    // 声音控制条
    _soundSlider = [[MPSlider alloc]initWithFrame:CGRectMake(32, 40, ScreamWidth-64, 30)];
    [_soundSlider setMinimumTrackTintColor:[UIColor colorWithRed:83/255.0 green:156/255.0 blue:245/255.0 alpha:1]];
    [_soundSlider setThumbImage:[UIImage imageNamed:@"soundSlider"] forState:UIControlStateNormal];
    [_soundSlider addTarget:self action:@selector(didChangeSound:) forControlEvents:UIControlEventValueChanged];
    _soundSlider.value = _playList.volume;
    [self.view addSubview:_soundSlider];
    
    // 播放面板
    _playPanel = [[BackgourdView alloc]initWithFrame:CGRectMake(0, ScreamHeight * 4/5, ScreamWidth, ScreamHeight * 1/5)];
    _playPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _playPanel.userInteractionEnabled = YES;    // 允许子视图交互/响应
    [self.view addSubview:_playPanel];
    
    // 音乐进度条
    _playSlider = [[MPSlider alloc]initWithFrame:CGRectMake(0, _playPanel.y - 15, ScreamWidth, 30)];
    [_playSlider setMinimumTrackTintColor:[UIColor colorWithRed:83/255.0 green:156/255.0 blue:245/255.0 alpha:1]];
    [_playSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small"] forState:UIControlStateNormal];
    [_playSlider addTarget:self action:@selector(didChangeProcess:) forControlEvents:UIControlEventValueChanged];
    _playSlider.continuous = NO; // 停止拖动的时候才改变值
    [self.view addSubview:_playSlider];
    
    // 时间进度
    _processLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 18, 50, 25)];
    _processLabel.text = @"00:00";
    _processLabel.textColor = [UIColor whiteColor];
    [_playPanel addSubview:_processLabel];
    
    // 时间总长
    _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreamWidth - 25 - 50, 18, 50, 25)];
    _totalLabel.text = @"00:00";
    _totalLabel.textColor = [UIColor whiteColor];
    [_playPanel addSubview:_totalLabel];
    
    // 播放/暂停 按钮
    _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    _playButton.size = _playButton.currentBackgroundImage.size;
    _playButton.origin = CGPointMake((_playPanel.width-_playButton.width)/2, (_playPanel.height - _playButton.width)/2 + 15);
    [_playButton addTarget:self action:@selector(didSelectePlay:) forControlEvents:UIControlEventTouchUpInside];
    [_playPanel addSubview:_playButton];
    
    // 前一首
    _aboveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboveButton setBackgroundImage:[UIImage imageNamed:@"aboveMusic"] forState:UIControlStateNormal];
    _aboveButton.size = _aboveButton.currentBackgroundImage.size;
    _aboveButton.origin = CGPointMake((_playButton.x - _aboveButton.width)/2 +10 ,_playButton.y);
    [_aboveButton addTarget:self action:@selector(didSelecteAbove:) forControlEvents:UIControlEventTouchUpInside];
    [_playPanel addSubview:_aboveButton];
    
    // 下一首
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"nextMusic"] forState:UIControlStateNormal];
    _nextButton.size = _nextButton.currentBackgroundImage.size;
    _nextButton.origin = CGPointMake(ScreamWidth - _aboveButton.width - _aboveButton.x,_playButton.y);
    [_nextButton addTarget:self action:@selector(didSelecteNext:) forControlEvents:UIControlEventTouchUpInside];
    [_playPanel addSubview:_nextButton];
}

- (void)didSelectePlay:(UIButton *)button
{
    if (![_player isPlaying])
    {
        if (!_player)
        {
            _player= [_playList playCurrentMusic];
        }
        [_player play];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self reSet];
        [self onExpired];
    }
    else
    {
        [_player stop];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)didSelecteAbove:(UIButton *)button
{
    if ([_player isPlaying])
    {
        _player= [_playList playAboveMusic];
        [_player play];
    }
    else
    {
        _player= [_playList playAboveMusic];
    }
    
    [self reSet];
}

- (void)didSelecteNext:(UIButton *)button
{
    if ([_player isPlaying])
    {
        _player= [_playList playNextMusic];
        [_player play];
    }
    else
    {
        _player= [_playList playNextMusic];
    }

    [self reSet];
}

- (void)didSelecteRandom:(UIButton *)button
{
    if ([_player isPlaying])
    {
        _player= [_playList playRandomMusic];
        [_player play];
    }
    else
    {
        _player= [_playList playRandomMusic];
    }
    [self reSet];
}

- (void)didChangeSound:(UISlider *)slider
{
    _player.volume = slider.value;
    _playList.volume = slider.value;
}

- (void)didChangeProcess:(UISlider *)slider
{
    _player.currentTime = slider.value * _player.duration;
    [self onExpired];
}

- (void)reSet
{
    //_processLabel.text = @"00:00";
    int time = _player.duration;
    _playSlider.value = 0.0;
    _totalLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",time/60,time%60];
    _player.delegate = self;
}

- (void)onExpired
{
    int time = _player.currentTime;
    _processLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",time/60,time%60];
    _playSlider.value = time / _player.duration;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _player= [_playList playNextMusic];
    [_player play];
    [self reSet];
}


@end
