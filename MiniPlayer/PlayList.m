//
//  PlayList.m
//  MiniPlayer
//
//  Created by Earth on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "PlayList.h"
#import "DataSource.h"

@interface PlayList ()

@property (nonatomic, strong) AVAudioPlayer     *player;
@property (nonatomic, strong) NSURL             *source;

@property (nonatomic, strong) NSArray           *musicNames;
@property (nonatomic, strong) NSArray           *musicTypes;

@property (nonatomic, unsafe_unretained) int    currentID;



@end

@implementation PlayList

// 初始化currentID
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _currentID = 0;
        _volume = 0.5;
        [self loadData];
    }
    return self;
}

// 加载数据
- (void)loadData
{
    NSArray *contents = [DataSource loadData];
    
    _musicNames = contents[0];
    _musicTypes = contents[1];

}

// 重置歌曲设置
- (void)playerStyle:(AVAudioPlayer *)player
{
    player.volume = _volume;
    player.currentTime = 0.0;
}

// 随机取歌
- (AVAudioPlayer *)playRandomMusic
{
    int ID = arc4random()%(_musicNames.count - 1);
    
    _source = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_musicNames[ID] ofType:_musicTypes[ID]]];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_source error:nil];
    
    [self playerStyle:_player];
    
    return _player;
}


// 向后切歌
- (AVAudioPlayer *)playNextMusic
{
    _currentID ++;
    if (_currentID >= _musicNames.count)
    {
        _currentID = 0;
    }
    _source = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_musicNames[_currentID] ofType:_musicTypes[_currentID]]];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_source error:nil];
    
    [self playerStyle:_player];
    
    return _player;
}

// 向前切歌
- (AVAudioPlayer *)playAboveMusic
{
    _currentID --;
    if (_currentID < 0 )
    {
        _currentID = _musicNames.count - 1.0;
    }
    _source = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_musicNames[_currentID] ofType:_musicTypes[_currentID]]];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_source error:nil];
    
    [self playerStyle:_player];
    
    return _player;
}

// 直接播放当前歌曲
- (AVAudioPlayer *)playCurrentMusic
{
    _source = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_musicNames[_currentID] ofType:_musicTypes[_currentID]]];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_source error:nil];
    
    [self playerStyle:_player];
    
    return _player;
}

@end
