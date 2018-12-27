//
//  ZMVideoView.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/25.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "ZMVideoView.h"

@implementation ZMVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addGestureRecognizer];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer];
    }
    return self;
}
- (void)addGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventMethod)];
    [self addGestureRecognizer:tap];
    self.videoView = [[UIView alloc] init];
    [self addSubview:self.videoView];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_videoView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_videoView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_videoView]-0-|" options:0 metrics:nil views:views]];
}
- (void)setHaveSound:(BOOL)haveSound {
    _haveSound = haveSound;
    if (haveSound) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }else{
        self.layer.borderWidth = 0;
    }
}
- (void)tapEventMethod {
    if (self.tapEvent&& !self.isBig) {
        self.isBig = YES;
        self.tapEvent();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
