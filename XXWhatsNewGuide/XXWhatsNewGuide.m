//
//  XXWhatsNewGuide.m
//  KKLife
//
//  Created by 许洵 on 2018/7/23.
//  Copyright © 2018年 com.vcredit. All rights reserved.
//

#import "XXWhatsNewGuide.h"
#import <objc/runtime.h>
static const char MaskViewKey = '\0';
FOUNDATION_STATIC_INLINE GuideView * NewGuideView(GuideCase *guideCase, UIView *subView) {
    GuideView *gv = [[GuideView alloc] init];
    [gv setValue:subView forKey:@"view"];
    [gv setValue:guideCase forKey:@"delegate"];
    NSMutableArray *subViews = [guideCase valueForKey:@"subViews"];
    [subViews addObject:gv];
    return gv;
}

@protocol GuideViewDelegate <NSObject>

- (void)guideViewActionForDismiss;
- (void)guideViewActionForNextCase:(GuideCase *)nextCase;

@end

@implementation XXWhatsNewGuide


+ (GuideCase *)giveMeACaseWithKey:(NSString *)key {
    GuideCase *gc = [[GuideCase alloc] init];
    [gc setValue:key forKey:@"key"];
    return gc;
}

@end

@interface GuideCase()<GuideViewDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray<GuideView *> *subViews;
@property (nonatomic, copy) NSString *key;

@end

@implementation GuideCase

- (instancetype)init {
    if (self = [super init]) {
        self.maskView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            view;
        });
        self.subViews = @[].mutableCopy;
    }
    return self;
}

- (void)show {
    BOOL alreadyShown = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"WNG_%@", self.key]];
    if (alreadyShown) {
        return;
    }
    
    //防止self被释放
    objc_setAssociatedObject(self.maskView, &MaskViewKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.maskView];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"WNG_%@", self.key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (GuideView *)addViewByCloneView:(UIView *)originalView {
    CGRect rect = [originalView.superview convertRect:originalView.frame toView:[UIApplication sharedApplication].keyWindow];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = [self imageFromView:originalView];
    [self.maskView addSubview:imgView];
    return NewGuideView(self, imgView);
}

- (GuideView *)addViewWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    [self.maskView addSubview:imgView];
    return NewGuideView(self, imgView);
}

- (GuideView *)addView:(UIView *)subView {
    [self.maskView addSubview:subView];
    return NewGuideView(self, subView);
}

- (void)hollowout:(CGRect)rect type:(HollowoutType)type radius:(CGFloat)radius {
    UIBezierPath *layerPath = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    if (type == HollowoutTypeRectangle) {
        UIBezierPath *hwPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        [layerPath appendPath:hwPath];
    } else if (type == HollowoutTypeOval) {
        UIBezierPath *hwPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        [layerPath appendPath:hwPath];
    }
    CAShapeLayer *hollowoutLayer = [CAShapeLayer layer];
    hollowoutLayer.path = layerPath.CGPath;
    hollowoutLayer.fillRule = kCAFillRuleEvenOdd;
    self.maskView.layer.mask = hollowoutLayer;
}

#pragma mark - GuideViewDelegate
- (void)guideViewActionForDismiss {
    [self.maskView removeFromSuperview];
    objc_removeAssociatedObjects(self.maskView); //打破循环
}

- (void)guideViewActionForNextCase:(GuideCase *)nextCase {
    [self guideViewActionForDismiss];
    [nextCase show];
}


#pragma mark - tool func
- (UIImage *)imageFromView:(UIView *)theView{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, [UIScreen mainScreen].scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)dealloc {
//    NSLog(@"GuideCase dealloc-%@", self);
}

@end


@interface GuideView ()

@property (nonatomic, strong) GuideCase *nextCase;
@property (nonatomic, weak) id<GuideViewDelegate> delegate;

@end

@implementation GuideView


- (void)addActionForDismiss {
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    [self.view addGestureRecognizer:tapG];
}

- (void)addActionForNextCase:(GuideCase *)nextCase {
    self.nextCase = nextCase;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextCaseAction)];
    [self.view addGestureRecognizer:tapG];
}

- (void)dismissAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewActionForDismiss)]) {
        [self.delegate guideViewActionForDismiss];
    }
}

- (void)nextCaseAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewActionForNextCase:)]) {
        [self.delegate guideViewActionForNextCase:self.nextCase];
    }
}

- (void)dealloc {
//    NSLog(@"GuideView dealloc-%@", self);
}

@end
