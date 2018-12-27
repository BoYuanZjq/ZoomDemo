//
//  ZMVideoView.h
//  ZoomDemo
//
//  Created by zjq on 2018/12/25.
//  Copyright © 2018 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMVideoView : UIView

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic,strong) NSString *peerId;
@property (nonatomic,strong) NSString *pubId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic, assign) BOOL isBig;
typedef void(^TapEvent)(void);
@property (nonatomic, copy) TapEvent tapEvent;

@property (nonatomic, assign) BOOL haveSound;

@end

NS_ASSUME_NONNULL_END
