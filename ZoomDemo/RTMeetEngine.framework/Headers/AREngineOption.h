//
//  AREngineOption.h
//  RTMeetEngine
//
//  Created by zjq on 2018/11/1.
//  Copyright © 2018 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AREngineKitCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface AREngineOption : NSObject
/**
 使用默认配置生成一个 AREngineOption 对象
 
 @return 生成的 AREngineOption 对象
 */
+ (nonnull AREngineOption *)defaultOption;
/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 设置视频质量
 说明:　默认：ARVideoProfileMiddle2
 */
@property (nonatomic, assign) ARVideoProfile videoProfile;

/**
 参会的最大人数(默认为4人，根据自己需求更改，建议不要超过9人)
 说明：该参数会在joinRoom的时候告诉服务最大支持人数：对应字段：MaxJoiner,请保持android、iOS、以及其他端保持统一。
 */
@property (nonatomic, assign) int maxNum;

@end

NS_ASSUME_NONNULL_END
