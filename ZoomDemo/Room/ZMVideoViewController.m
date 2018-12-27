//
//  ZMVideoViewController.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/25.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "ZMVideoViewController.h"
#import <RTMeetEngine/RTMeetSDK.h>
#import "ZMVideoLayoutView.h"

@interface ZMVideoViewController ()<RTMeetKitDelegate>

@property (nonatomic, strong) RTMeetKit *meetKit;

@property (nonatomic, strong) ZMVideoLayoutView *videoLayoutView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) AnyZoomType zoomType;

@end

@implementation ZMVideoViewController
- (void)dealloc {
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollowView];
    [self initMeetKit];
    
}

- (void)initScrollowView {
    if (!self.videoLayoutView) {
        _videoLayoutView = [[ZMVideoLayoutView alloc] initWithFrame:self.view.frame];
        __weak typeof(self)weakSelf = self;
        _videoLayoutView.pageBlock = ^(int index) {
            [weakSelf changeZoomModel:index];
        };
        [self.view addSubview:_videoLayoutView];

        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-30 , self.view.bounds.size.width, 30)];
        [self.view addSubview:self.pageControl];
        
        
        UIButton*closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.frame = CGRectMake(20, 20, 50, 40);
        [self.view addSubview:closeButton];
    }
}
- (void)initMeetKit {
    RTMeetOption *option = [RTMeetOption defaultOption];
    option.videoScreenOrientation =  RTC_SCRN_Auto;
    option.videoMode = AnyRTCVideoQuality_Low2;
    option.maxNum = 32;
    // 设置zoom 模式
    option.meetingType = AnyMeetingTypeZoom;
    self.meetKit = [[RTMeetKit alloc] initWithDelegate:self andOption:option];
    // 自己平台用户Id
    NSString *userID = [NSString stringWithFormat:@"%d",arc4random()%10];
    //加入房间
    [self.meetKit joinRTC:self.meetId andIsHoster:NO andUserId:userID andUserData:@"{}"];
    //打开网络检测
    [self.meetKit setNetworkStatus:YES];
    //打开音频检测（有人说话的音量大小）
    [self.meetKit setAudioActiveCheck:YES];
}
- (void)closeButtonEvent:(UIButton*)sender {
    // 离开频道，释放资源
    [self.meetKit leaveRTC];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeZoomModel:(int)index {
    switch (index) {
        case 0:
        {
            //驾驶模式
            [self.meetKit setZoomModel:AnyZoomTypeDriver];
            //禁止传输视频，此时可以说话，只拉去音频
            [self.meetKit setLocalVideoEnable:NO];
        }
            break;
        case 1:
        {
            // 单显示模式（本地视频打开）
            [self.meetKit setLocalVideoEnable:YES];
            // 设置单显模式
            [self.meetKit setZoomModel:AnyZoomTypeSingle];
        }
            break;
        default:
        {
            // 设置分屏显示
            if (self.zoomType != AnyZoomTypeNomal) {
                [self.meetKit setZoomModel:AnyZoomTypeNomal];
            }
            [self.meetKit setLocalVideoEnable:YES];
            // 设置页码
            [self.meetKit setZoomPage:index-2];
        }
            break;
    }
}

#pragma mark - RTMeetKitDelegate

- (void)onRTCJoinMeetOK:(NSString*)strAnyRTCId {
    [self.meetKit setLocalVideoCapturer:self.videoLayoutView.myVideoView];
    [self.meetKit setZoomModel:AnyZoomTypeSingle];
}

- (void)onRTCJoinMeetFailed:(NSString*)strAnyRTCId withCode:(int)nCode {

}

- (void)onRTCConnectionLost {

}

-(void)onRTCLeaveMeet:(int) nCode {

}

-(void)onRTCOpenVideoRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData {
    ZMVideoView *view = [[ZMVideoView alloc] init];
    view.peerId = strRTCPeerId;
    view.pubId = strRTCPubId;
    view.userId = strUserId;
    __weak typeof(self)weakSelf = self;
    view.tapEvent = ^() {
        if (weakSelf.zoomType==AnyZoomTypeSingle) {
            weakSelf.videoLayoutView.myVideoView.isBig = NO;
        }
        [weakSelf.videoLayoutView layout];
    };
    if (![strRTCPeerId isEqualToString:@"RTCMainParticipanter"]) {
        [self.meetKit setRTCVideoRender:strRTCPubId andRender:view.videoView];
    }
    [self.videoLayoutView.remoteArray addObject:view];
    [self.videoLayoutView layout];
}

-(void)onRTCCloseVideoRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId {
    for (ZMVideoView *view in self.videoLayoutView.remoteArray) {
        if ([view.peerId isEqualToString:strRTCPeerId]) {
            [view removeFromSuperview];
            [self.videoLayoutView.remoteArray removeObject:view];
            break;
        }
    }
    [self.videoLayoutView layout];
}

-(void)onRTCOpenScreenRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData {
    
}

-(void)onRTCCloseScreenRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId {
    
}

-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo {

}

-(void)onRTCAVStatusForMe:(BOOL)bAudio video:(BOOL)bVideo {

}

-(void)onRTCAudioActive:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withAudioLevel:(int)nLevel withShowTime:(int)nTime {

}

#if TARGET_OS_IPHONE
-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size {

}
#else
#endif

- (void)onRtcNetworkStatus:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withNetSpeed:(int)nNetSpeed withPacketLost:(int)nPacketLost {

}

- (void)onRTCUserMessage:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent {

}

- (void)onRTCHosterOnLine:(NSString*)strRTCPeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData {

}

- (void)onRTCHosterOffLine:(NSString*)strRTCPeerId {

}

- (void)onRTCTalkOnlyOn:(NSString*)strRTCPeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData {
    
}

- (void)onRtcTalkOnlyOff:(NSString*)strRTCPeerId {
    
}

- (void)onRTCZoomPageInfo:(AnyZoomType)nZoomType allPage:(int)nAllPage currentPage:(int)nCurrentPage allRenderNum:(int)nAllRenderNum beginIndex:(int)nIndex showNum:(int)nShowNum {
    self.zoomType = nZoomType;
    [self.videoLayoutView zoomPageInfo:nZoomType allPage:nAllPage currentPage:nCurrentPage allRenderNum:nAllRenderNum beginIndex:nIndex showNum:nShowNum];
    self.pageControl.numberOfPages = self.videoLayoutView.viewsArray.count;
    self.pageControl.currentPage = self.videoLayoutView.viewIndex;

    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (self.videoLayoutView.frame.size.width != size.width) {
        self.videoLayoutView.frame = CGRectMake(0, 0, size.width, size.height);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
