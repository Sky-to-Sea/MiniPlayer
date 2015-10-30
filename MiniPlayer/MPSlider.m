//
//  MPSlider.m
//  MiniPlayer
//
//  Created by Earth on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "MPSlider.h"

@implementation MPSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 25;
    rect.size.width = rect.size.width + 50;
    return [super thumbRectForBounds:bounds trackRect:rect value:value];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setMaximumTrackTintColor:[UIColor whiteColor]];
    }
    return self;
}

@end
