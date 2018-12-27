//
//  AREngineKitCommon.h
//  RTMeetEngine
//
//  Created by zjq on 2016/11/10.
//  Copyright © 2018 EricTao. All rights reserved.
//

#ifndef AREngineKitCommon_h
#define AREngineKitCommon_h


typedef NS_ENUM(NSInteger,AREngineErrorCode) {
    
    AR_OK = 0,                     // 正常
    AR_UNKNOW,                     // 未知错误
    AR_EXCEPTION,                  // SDK调用异常
    AR_EXP_UNINIT,                 // SDK未初始化
    AR_EXP_PARAMS_INVALIDE,        // 参数非法
    AR_EXP_NO_NETWORK,             // 没有网络
    AR_EXP_NOT_FOUND_CAMERA,       // 没有找到摄像头设备
    AR_EXP_NO_CAMERA_PERMISSION,   // 没有打开摄像头权限:
    AR_EXP_NO_AUDIO_PERMISSION,    // 没有音频录音权限
    AR_EXP_NOT_SUPPORT_WEBRTC,     // 浏览器不支持原生的webrtc
    
    AR_NET_ERR = 100,              // 网络错误
    AR_NET_DISSCONNECT = 101,      // 网络断开
    AR_LIVE_ERR = 102,             // 直播出错
    AR_EXP_ERR = 103,              // 异常错误
    AR_EXP_UNAUTHORIZED = 104,     // 服务未授权
    
    AR_BAD_REQ  = 201,             // 服务不支持的错误请求
    AR_AUTH_FAIL = 202,            // 认证失败
    AR_NO_USER= 203,               // 此开发者信息不存在
    AR_SVR_ERR = 204,              // 服务器内部错误
    AR_SQL_ERR = 205,              // 服务器内部数据库错误
    AR_ARREARS = 206,              // 账号欠费
    AR_LOCKED = 207,               // 账号被锁定
    AR_SERVER_NOT_OPEN = 208,      // 服务未开通
    AR_ALLOC_NO_RES = 209,         // 没有服务资源
    AR_SERVER_NO_SURPPORT = 210,   // 不支持的服务
    AR_FORCE_EXIT = 211,           // 强制离开
    
    AR_NOT_START = 700,            // 房间未开始
    AR_IS_FULL = 701,              // 房间人员已满
    AR_NOT_COMPARE =702            // 房间类型不匹配
};


// 分辨率
typedef NS_ENUM(NSInteger,ARVideoProfile) {
    
    ARVideoProfileLow1 = 0,      // 320*240 - 128kbps
    ARVideoProfileLow2,          // 352*288 - 256kbps
    ARVideoProfileLow3,          // 352*288 - 384kbps
    ARVideoProfileMiddle1,       // 640*480 - 384kbps
    ARVideoProfileMiddle2,       // 640*480 - 512kbps
    ARVideoProfileMiddle3,       // 640*480 - 768kbps
    ARVideoProfileHeight1,       // 960*540 - 1024kbps
    ARVideoProfileHeight2,       // 1280*720 - 1280kbps
    ARVideoProfileHeight3,       // 1920*1080 - 2048kbps
};

@protocol AREngineKitDelegate <NSObject>
@optional

/**
 进入房间成功
 */
- (void)onJoinRoomOK;

/**
 进入房间出错

 @param eCode 原因
 */
- (void)onJoinRoomFailed:(AREngineErrorCode)eCode;

/**
 RTC服务已断开
 说明:收到该消息后，在网络恢复后，会有重连，重连成功，会有onJoinRoomOK回调
 */
- (void)onRoomConnectionLost;

/**
 离开房间

 @param eCode 原因
 */
- (void)onLeaveRoom:(AREngineErrorCode)eCode;

/**
 有人加入房间

 @param strPeerId 系统给予用户的身份ID
 @param strPubId 系统给予用户的发布流ID
 @param userId 用户的ID
 @param userData 用户的自定义消息
 */
- (void)onRemoteJoinRoom:(NSString*)strPeerId pubID:(NSString*)strPubId userID:(NSString*)userId userData:(NSString*)userData;

/**
 有人离开房间

 @param strPeerId 系统给予用户的身份ID
 @param strPubId 系统给予用户的发布流ID
 @param userId 用户的ID
 */
- (void)onRemoteLeaveRoom:(NSString*)strPeerId pubID:(NSString*)strPubId userID:(NSString*)userId;

/**
 与会者音视频状态

 @param strPeerId 系统给予用户的身份ID
 @param bAudio YES:为打开音频，NO:为关闭音频
 @param bVideo  YES:为打开视频，NO:为关闭视频
 说明:其他人关闭音频或者视频的状态回调
 */

- (void)onAVStatus:(NSString*) strPeerId audio:(BOOL)bAudio video:(BOOL)bVideo;

/**
 音频检测
 
 @param strPeerId 系统给予用户的身份ID
 @param strUserId 用户的ID
 @param nLevel 音频检测音量；（0~100）
 @param nTime 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）；
 说明：对方关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调；对方关闭音频检测后（setAudioActiveCheck为NO）,该回调也将不再回调。
 */
- (void)onAudioActive:(NSString*)strPeerId userId:(NSString *)strUserId audioLevel:(int)nLevel showTime:(int)nTime;

/**
 收到消息回调
 
 @param strUserId 发送消息者在自己平台下的Id；
 @param strUserName 发送消息者的昵称
 @param strUserHeaderUrl 发送者的头像
 @param strContent 消息内容
 说明：该参数来源均为发送消息时所带参数。
 */

- (void)onUserMessage:(NSString*)strUserId userName:(NSString*)strUserName userHeader:(NSString*)strUserHeaderUrl content:(NSString*)strContent;

@end

#endif /* AREngineKitCommon_h */
