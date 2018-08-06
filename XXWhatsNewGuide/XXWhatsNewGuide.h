//
//  XXWhatsNewGuide.h
//  KKLife
//
//  Created by 许洵 on 2018/7/23.
//  Copyright © 2018年 com.vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GuideCase;
//镂空区域样式类型
typedef NS_ENUM(NSUInteger, HollowoutType) {
    HollowoutTypeRectangle, //矩形
    HollowoutTypeOval, //椭圆
};

NS_ASSUME_NONNULL_BEGIN
@interface GuideView : NSObject

@property (nonatomic, strong, readonly) UIView *view;

/**
 点击消失
 */
- (void)addActionForDismiss;


/**
 点击显示下一步引导界面

 @param nextCase nextCase
 */
- (void)addActionForNextCase:(GuideCase *)nextCase;

@end

@interface GuideCase : NSObject


/**
 蒙版透明度，默认0.6
 */
@property (nonatomic, assign) CGFloat maskAlpha;

/**
 添加视图内容的替身到蒙层上，不需要设置frame

 @param originalView 原始的View
 @return 新加的View
 */
- (GuideView *)addViewByCloneView:(UIView *)originalView;

/**
 在蒙层上添加图片

 @param image 添加的图片
 @param frame 图片位置
 @return 新加的View
 */
- (GuideView *)addViewWithImage:(UIImage *)image frame:(CGRect)frame;


/**
 在蒙层上添加视图

 @param subView 要添加的视图
 @return 新加的View，即subView
 */
- (GuideView *)addView:(UIView *)subView;


/**
 镂空区域

 @param rect 镂空区域rect
 @param type 镂空类型
 @param radius HollowoutType == HollowoutTypeRectangle 时，可设置圆角
 */
- (void)hollowout:(CGRect)rect type:(HollowoutType)type radius:(CGFloat)radius;


- (void)show;

/**
 全屏点击消失
 */
- (void)addFullScreenActionForDismiss;


/**
  全屏点击显示下一步引导界面
 
 @param nextCase nextCase
 */
- (void)addFullScreenActionForNextCase:(GuideCase *)nextCase;

@end

@interface XXWhatsNewGuide : NSObject

/**
 每个引导case对应一个唯一key

 @param key key
 @return GuideCase
 */
+ (GuideCase *)giveMeACaseWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END




