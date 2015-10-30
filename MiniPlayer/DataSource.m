//
//  DataSource.m
//  MiniPlayer
//
//  Created by Earth on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+(NSArray *)loadData
{
    NSArray *musicNames = @[@"不再犹豫",@"喜欢你",@"海阔天空"];
    NSArray *musicTypes = @[@"mp3",@"mp3",@"mp3"];
    
    NSArray *contents = [NSArray arrayWithObjects:musicNames,musicTypes, nil];
    
    return contents;
}

@end
