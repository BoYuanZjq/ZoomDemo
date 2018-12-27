//
//  ZMScrollView.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/25.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "ZMScrollView.h"
#import "ZMDriveView.h"

@interface ZMScrollView()<UIScrollViewDelegate>

@end

@implementation ZMScrollView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        //设置scrollView按页滚动
        self.pagingEnabled = YES;
     
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.delegate = self;
        self.viewsArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.remoteArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.viewIndex = 1;
        // 驾驶View
        ZMDriveView *driveView = [[ZMDriveView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.viewsArray addObject:driveView];
        [self addSubview:driveView];
        
        UIView *singleView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        self.myVideoView = [[ZMVideoView alloc] initWithFrame:singleView.bounds];
        __weak typeof(self)weakSelf = self;
        self.myVideoView.tapEvent = ^{
            if (weakSelf.viewIndex==1) {
                if (weakSelf.viewsArray.count!=0) {
                    ZMVideoView *playView = [weakSelf.remoteArray firstObject];
                    playView.isBig = NO;
                }
            }
            [weakSelf layout];
        };
        [singleView addSubview:self.myVideoView];
        [self.viewsArray addObject:singleView];
        [self addSubview:singleView];
        
        self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
        
        CGPoint point =CGPointMake(self.viewIndex*self.bounds.size.width, 0);
        [self setContentOffset:point animated:NO];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self changeFrame];
    }
}

- (void)changeFrame {
    // 白板视图更改
    for (int i=0; i<self.viewsArray.count; i++) {
        UIView *drawView = [self.viewsArray objectAtIndex:i];
        drawView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    //重新整理画板
    self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
    [self setContentOffset:CGPointMake((self.viewIndex)*self.bounds.size.width, 0) animated:NO];
    // 刷新布局
    [self layout];
}

- (void)zoomPageInfo:(AnyZoomType)nZoomType allPage:(int)nAllPage currentPage:(int)nCurrentPage allRenderNum:(int)nAllRenderNum beginIndex:(int)nIndex showNum:(int)nShowNum {
    switch (nZoomType) {
        case 0:
        {
            [self nomalZoomallPage:nAllPage currentPage:nCurrentPage allRenderNum:nAllRenderNum beginIndex:nIndex showNum:nShowNum];
        
        }
            break;
        case 1:
        {
            self.viewIndex = 1;
            [self updateViews:nAllPage];
        }
            break;
        case 2:
        {
            self.viewIndex = 0;
            //驾驶模式
            [self updateViews:nAllPage];
        }
            break;
        default:
            break;
    }
    [self layout];
}

- (void)nomalZoomallPage:(int)nAllPage currentPage:(int)nCurrentPage allRenderNum:(int)nAllRenderNum beginIndex:(int)nIndex showNum:(int)nShowNum
{
    if (nAllRenderNum>nShowNum) {
        if (self.viewsArray.count < 2+nAllPage) {
            int numPage = (2+nAllPage) - (int)self.viewsArray.count;
            for (int i = 0; i<numPage; i++) {
                UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
                splitView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
                [self.viewsArray addObject:splitView];
            }
            for (int i= (int)self.viewsArray.count-numPage; i>=self.viewsArray.count-1; i--) {
                UIView *tempView = [self.viewsArray objectAtIndex:i];
                tempView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                [self addSubview:tempView];
                
            }
            self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
        }else if(self.viewsArray.count>2+nAllPage){
            UIView *tempView = [self.viewsArray lastObject];
            [tempView removeFromSuperview];
            [self.viewsArray removeObject:tempView];
            self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
            self.viewIndex = (int)(self.viewsArray.count-1);
            CGPoint point =CGPointMake(self.viewIndex*self.bounds.size.width, 0);
            [self setContentOffset:point animated:YES];
        }
    }else if (nAllRenderNum == 2){
        // 减去一页
        UIView *tempView = [self.viewsArray lastObject];
        [tempView removeFromSuperview];
        [self.viewsArray removeObject:tempView];
        self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
        self.viewIndex = (int)(self.viewsArray.count-1);
        CGPoint point =CGPointMake(self.viewIndex*self.bounds.size.width, 0);
        [self setContentOffset:point animated:YES];
        
    }else if (nAllRenderNum <= nShowNum) {
        if (self.viewIndex>2+nCurrentPage) {
            //减去一页
            UIView *tempView = [self.viewsArray lastObject];
            [tempView removeFromSuperview];
            [self.viewsArray removeObject:tempView];
            self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
            self.viewIndex = (int)(self.viewsArray.count-1);
            CGPoint point =CGPointMake(self.viewIndex*self.bounds.size.width, 0);
            [self setContentOffset:point animated:YES];
        }else if (self.viewIndex==2+nCurrentPage) {
            if (self.viewsArray.count > 2 + nAllPage) {
                UIView *tempView = [self.viewsArray lastObject];
                [tempView removeFromSuperview];
                [self.viewsArray removeObject:tempView];
                self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
                self.viewIndex = (int)(self.viewsArray.count-1);
                CGPoint point =CGPointMake(self.viewIndex*self.bounds.size.width, 0);
                [self setContentOffset:point animated:YES];
            }
        }
    }
}
//页码更新（驾驶模式、单显模式）
- (void)updateViews:(int)nAllPage {
    //判断是否需要添加或者删除view
    if (self.viewsArray.count<2+nAllPage) {
        for (int i = 0; i<(2+nAllPage)-self.viewsArray.count; i++) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
            splitView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
            [self.viewsArray addObject:splitView];
        }
        for (int i= (int)self.viewsArray.count-1 -nAllPage; i<self.viewsArray.count; i++) {
            UIView *tempView = [self.viewsArray objectAtIndex:i];
            tempView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:tempView];
        }
        self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
        
        
    }else if (self.viewsArray.count>2+nAllPage) {
        int index = (int)(2+nAllPage -1);
        for (int i= (int)(self.viewsArray.count-1);i>index;i--) {
            UIView *tempView = [self.viewsArray objectAtIndex:i];
            [tempView removeFromSuperview];
            [self.viewsArray removeObject:tempView];
        }
        self.contentSize = CGSizeMake(self.viewsArray.count*self.bounds.size.width, self.bounds.size.height);
    }
}


// 布局
- (void)layout {
    switch (self.viewIndex) {
        case 0:
            // 驾驶模式
            break;
        case 1:
            // 单线模式
        {
            UIView *singView = [self.viewsArray objectAtIndex:1];
            if (self.remoteArray.count==0) {
                if (self.myVideoView.superview) {
                    [self.myVideoView removeFromSuperview];
                }
                self.myVideoView.frame = self.frame;
                [singView addSubview:self.myVideoView];
                [singView sendSubviewToBack:self.myVideoView];
            }else{
                CGFloat X = CGRectGetWidth(self.frame) -90 -10;
                CGFloat Y = CGRectGetHeight(self.frame)-120 -10;
                CGFloat width = 90;
                CGFloat height = 120;
                ZMVideoView *otherView = [self.remoteArray firstObject];
                if (otherView.superview) {
                    [otherView removeFromSuperview];
                }
                if (self.myVideoView.superview) {
                    [self.myVideoView removeFromSuperview];
                }
                if (!self.myVideoView.isBig) {
                    otherView.frame = self.frame;
                    [singView addSubview:otherView];
                    [singView sendSubviewToBack:otherView];
                    
                    self.myVideoView.frame = CGRectMake(X, Y, width, height);
                    [singView addSubview:self.myVideoView];
                }else{
                    self.myVideoView.frame = self.frame;
                    [singView addSubview:self.myVideoView];
                    [singView sendSubviewToBack:self.myVideoView];
                    
                    otherView.frame = CGRectMake(X, Y, width, height);
                    [singView addSubview:otherView];
                }
            }
        }
            break;
        default:
            // 平分显示
            
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / scrollView.bounds.size.width;
    if (autualIndex==self.viewIndex) {
        return;
    }
    if (self.pageBlock) {
        self.pageBlock(autualIndex);
    }
    self.viewIndex = autualIndex;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
