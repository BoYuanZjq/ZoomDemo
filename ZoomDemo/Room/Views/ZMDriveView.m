//
//  ZMDriveView.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/25.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "ZMDriveView.h"

@implementation ZMDriveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"驾驶模式";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:26];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
