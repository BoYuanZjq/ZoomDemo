//
//  ZMVideoLayoutView.h
//  ZoomDemo
//
//  Created by zjq on 2018/12/26.
//  Copyright © 2018 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMVideoView.h"
#import <RTMeetEngine/RTMeetSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedPageBlock)(int index);

@interface ZMVideoLayoutView : UIView
// 滚动图
@property (nonatomic, strong) UIScrollView *scrollView;
// 视图数组
@property (nonatomic, strong) NSMutableArray *viewsArray;
// 远程视图
@property (nonatomic, strong) NSMutableArray *remoteArray;
// 当前索引
@property (nonatomic, assign) int viewIndex;
// 本地视图
@property (nonatomic, strong) ZMVideoView *myVideoView;

@property (nonatomic, copy) SelectedPageBlock pageBlock;
// 布局
- (void)layout;

- (void)zoomPageInfo:(AnyZoomType)nZoomType allPage:(int)nAllPage currentPage:(int)nCurrentPage allRenderNum:(int)nAllRenderNum beginIndex:(int)nIndex showNum:(int)nShowNum;

@end

NS_ASSUME_NONNULL_END
