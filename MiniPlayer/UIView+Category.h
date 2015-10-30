//
//  UIView+Category.h
//  神马微博
//
//  Created by Earth on 15/10/23.
//  Copyright (c) 2015年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (nonatomic,unsafe_unretained) CGFloat width;
@property (nonatomic,unsafe_unretained) CGFloat height;
@property (nonatomic,unsafe_unretained) CGFloat x;
@property (nonatomic,unsafe_unretained) CGFloat y;
@property (nonatomic,unsafe_unretained) CGSize  size;
@property (nonatomic,unsafe_unretained) CGPoint origin;

- (void)setMultipleSize:(float)multiple;

@end
