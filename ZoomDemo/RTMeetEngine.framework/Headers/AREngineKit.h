//
//  AREngineKit.h
//  RTMeetEngine
//
//  Created by zjq on 2016/11/10.
//  Copyright © 2018 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AREngineKitCommon.h"
#import "AREngineOption.h"

@interface AREngineKit : NSObject

/**
 实例化对象

 @param delegate 回调代理
 @return 对象
 */
- (instancetype)initEngine:(id<AREngineKitDelegate>)delegate;

/**
 配置开发者信息

 @param strDeveloperId developerId
 @param strAppId     appId
 @param strKey    key
 @param strToken  token
 */
- (void)configEngine:(NSString*)strDeveloperId appID:(NSString*)strAppId key:(NSString*)strKey token:(NSString*)strToken;

/**
 配置私有云

 @param strServer 私有云地址
 @param nPort 端口
 */
- (void)configServer:(NSString*)strServer port:(int)nPort;

#pragma mark 本地摄像头操作
/**
 设置本地预览
 
 @param render 显示窗口
 @param option 本地视频配置
 */

- (void)setLocalVideoCapturer:(UIView*)render option:(AREngineOption*)option;
/**
 设置本地音频是否传输
 
 @param bEnable 打开或关闭本地音频
 说明：yes为传输音频,no为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(bool)bEnable;
/**
 设置本地视频是否传输
 
 @param bEnable 打开或关闭本地视频
 说明：yes为传输视频，no为不传输视频，默认视频传输
 */
- (void)setLocalVideoEnable:(bool)bEnable;
/**
 获取本地音频传输是否打开
 
 @return 音频传输与否
 */
- (BOOL)localAudioEnabled;
/**
 获取本地视频传输是否打开
 
 @return 视频传输与否
 */
- (BOOL)localVideoEnabled;
/**
 切换前后摄像头
 说明:切换本地前后摄像头。
 */
- (void)switchCamera;
/**
 设置音频检测
 
 @param bOn 是否开启音频检测
 说明：默认打开
 */
- (void)setAudioActiveCheck:(bool)bOn;
/**
 设置本地前置摄像头镜像是否打开
 
 @param bEnable YES为打开，NO为关闭
 @return 镜像成功与否
 */
- (BOOL)setFontCameraMirrorEnable:(BOOL)bEnable;

#pragma mark 房间操作
/**
 加入会议
 
 @param strRoomId 房间号（确保开启者平台唯一）
 @param strUserId 用户ID
 @param strUserData 用户自定义信息
 @return 加入房间成功或者失败
 */
- (BOOL)joinRoom:(NSString*)strRoomId userId:(NSString*)strUserId userData:(NSString*)strUserData;
/**
 离开房间
 说明：相当于析构函数
 */
- (void)leaveRoom;
/**
 设置显示其他端视频窗口
 
 @param strPubId 其他用户的发布Id
 @param render 对方视频的窗口
 说明：该方法用于与其他人进入房间（onRemoteJoinRoom）后使用。
 */
- (void)setRemoteVideoRender:(NSString*)strPubId render:(UIView *)render;
/**
 发送消息
 
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像(最大512字节)，可选
 @param strContent 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：默认普通消息。以上参数均会出现在参会者的消息回调方法中，如果加入RTC（joinRoom）没有设置strUserid，发送失败。
 */
- (BOOL)sendUserMessage:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;


@end
