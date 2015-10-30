//
//  PlayList.h
//  MiniPlayer
//
//  Created by Earth on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayList : NSObject

@property (nonatomic, unsafe_unretained) CGFloat    volume;

- (AVAudioPlayer *)playRandomMusic;
- (AVAudioPlayer *)playNextMusic;
- (AVAudioPlayer *)playAboveMusic;
- (AVAudioPlayer *)playCurrentMusic;

@end
