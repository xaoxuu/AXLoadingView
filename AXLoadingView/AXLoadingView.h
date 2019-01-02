//
//  AXLoadingView.h
//  AXLoadingView
//
//  Created by xaoxuu on 2019/1/2.
//  Copyright © 2019 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AXLoadingView.
FOUNDATION_EXPORT double AXLoadingViewVersionNumber;

//! Project version string for AXLoadingView.
FOUNDATION_EXPORT const unsigned char AXLoadingViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AXLoadingView/PublicHeader.h>


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 样式
 
 - AXLoadingViewStyleLinear: 线形
 - AXLoadingViewStyleCircular: 圆环形
 */
typedef NS_ENUM(NSInteger, AXLoadingViewStyle) {
    AXLoadingViewStyleLinear,
    AXLoadingViewStyleCircular
};

NS_ASSUME_NONNULL_BEGIN

@interface AXLoadingView : UIView

/**
 样式，如果是环形，则宽高比定相等且等于设定的宽高的最小值
 */
@property(assign, readonly, nonatomic) AXLoadingViewStyle style;

/**
 进度，默认为-1
 当【progress >= 0】时，是Determinate模式的进度条
 当【progress < 0】时，是Indeterminate模式的进度条
 */
@property(assign, nonatomic) CGFloat progress;

/**
 进度颜色
 */
@property(strong, nonatomic) UIColor *progressColor;

/**
 轨道颜色
 */
@property(strong, nonatomic) UIColor *trackColor;

/**
 轨道宽度
 */
@property(assign, nonatomic) CGFloat trackWidth;

/**
 创建一个AXLoadingView
 
 @param frame frame
 @param style 样式
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame style:(AXLoadingViewStyle)style;

@end

NS_ASSUME_NONNULL_END
