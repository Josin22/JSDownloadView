//
//  JSAnimationService.m
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/30.
//  Copyright © 2016年 乔同新. All rights reserved.
//https://github.com/Josin22/JSDownloadView

#import "JSAnimationService.h"

//箭头比例
static const double arrowHScale = 130.00/250.00;
//箭头头部高比例
static const double arrowTWScale = 96.00/250.00;
static const double arrowTHScale = 50.00/250.00;
//
static const double lineWScale = 176.00/250.00;
static const double pointSpacingScale = 16.00/250.00;

static const double successPoint1ScaleX = 90.00/250.00;
static const double successPoint1ScaleY = 126.00/250.00;

static const double successPoint2ScaleX = 120.00/250.00;
static const double successPoint2ScaleY = 160.00/250.00;

static const double successPoint3ScaleX = 177.00/250.00;
static const double successPoint3ScaleY = 95.00/250.00;

static const  NSInteger  kSpacing = 2;

/*************     animationWithKeyPath     **************/
//比例转化
static  NSString *keyPath_Scale = @"transform.scale";
//宽的比例
static  NSString *keyPath_ScaleX = @"transform.scale.x";
///高的比例
static  NSString *keyPath_ScaleY = @"transform.scale.y";
//围绕x轴旋转
static  NSString *keyPath_RotationX = @"transform.rotation.x";
//围绕y轴旋转
static  NSString *keyPath_RotationY = @"transform.rotation.y";
//围绕z轴旋转
static  NSString *keyPath_RotationZ = @"transform.rotation.z";
//圆角的设置
static  NSString *keyPath_Radius = @"cornerRadius";
//
static  NSString *keyPath_bgColor = @"backgroundColor";
//
static  NSString *keyPath_Bounds = @"bounds";
//
static  NSString *keyPath_Position = @"position";

static  NSString *keyPath_PositionX = @"position.x";

static  NSString *keyPath_PositionY = @"position.y";

static  NSString *keyPath_Path = @"path";

static  NSString *keyPath_Contents = @"contents";

static  NSString *keyPath_Opacity = @"opacity";

static  NSString *keyPath_ContentW = @"contentsRect.size.width";


@interface JSAnimationService ()
{
    CGFloat halfSquare;
    CGFloat arrowLineH;
    CGFloat arrowTH;
    CGFloat arrowTW;
    CGFloat linePoinY;
    CGFloat arrowPointX;
    CGFloat arrowPointY;
    CGFloat lineW;
    CGFloat midPointX;
    CGFloat pointSpacing;
    CGFloat verticalLineEndPointX;
    CGFloat verticalLinePointX;
    CGFloat waveHeight;
}
@end

@implementation JSAnimationService

- (CAAnimationGroup *)getLineToPointUpAnimationWithValues:(NSArray *)values{

    CAKeyframeAnimation *lineAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath_Path];
    lineAnimation.values = values;
    lineAnimation.keyTimes = @[@0,@.15];
    lineAnimation.beginTime= 0.0;
    
    CASpringAnimation *lineUpAnimation = [CASpringAnimation animationWithKeyPath: keyPath_PositionY];
    lineUpAnimation.toValue = @6;
    lineUpAnimation.damping = 10;
    lineUpAnimation.mass = 1;
    lineUpAnimation.initialVelocity = 0;
//    lineUpAnimation.duration = lineUpAnimation.settlingDuration;
    lineUpAnimation.beginTime= 0.50;
    lineUpAnimation.removedOnCompletion = NO;
    lineUpAnimation.fillMode = kCAFillModeForwards;
    // 线->点 and 上弹
    CAAnimationGroup *lineGroup = [CAAnimationGroup animation];
    lineGroup.delegate = self;
    lineGroup.animations = @[lineAnimation,lineUpAnimation];
    lineGroup.duration = 1.5;
    lineGroup.repeatCount = 1;
    lineGroup.removedOnCompletion = NO;
    lineGroup.fillMode = kCAFillModeForwards;
    lineGroup.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return lineGroup;
}

- (CAAnimationGroup *)getArrowToLineAnimationWithValues:(NSArray *)values{
    
    CAKeyframeAnimation *arrowChangeAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath_Path];
    arrowChangeAnimation.values = values;
    arrowChangeAnimation.keyTimes = @[@0,@.15,@.25,@.28];
    //箭头形变直线
    CAAnimationGroup *arrowGroup = [CAAnimationGroup animation];
    arrowGroup.delegate  = self;
    arrowGroup.animations = @[arrowChangeAnimation];
    arrowGroup.duration  = 2;
    arrowGroup.repeatCount  = 1;
    arrowGroup.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return arrowGroup;
}

- (void)setViewRect:(CGRect)viewRect{
    
    _viewRect = viewRect;
    
    CGFloat viewWidth = CGRectGetWidth(viewRect);
    
    halfSquare = viewWidth/2;
    
    arrowLineH = viewWidth * arrowHScale;

    arrowTH = viewWidth * arrowTHScale;
    arrowTW = viewWidth * arrowTWScale;
    
    linePoinY = (viewWidth-arrowLineH)/2;
    arrowPointX = (viewWidth-arrowTW)/2;
    arrowPointY = viewWidth-(linePoinY+arrowTH);
    
    lineW = viewWidth * lineWScale;
    
    midPointX = (viewWidth-lineW)/2;

    pointSpacing = pointSpacingScale *viewWidth;
    
    verticalLineEndPointX = halfSquare-pointSpacing;

    verticalLinePointX = (viewWidth-arrowLineH)/2;
}
//箭头开始
- (UIBezierPath *)arrowStartPath{
    
    _arrowStartPath = [UIBezierPath bezierPath];
    [_arrowStartPath moveToPoint:CGPointMake(arrowPointX, arrowPointY)];
    [_arrowStartPath addLineToPoint:CGPointMake(halfSquare,linePoinY+arrowLineH)];
    [_arrowStartPath addLineToPoint:CGPointMake(arrowPointX+arrowTW, arrowPointY)];
    
    return _arrowStartPath;
}
//箭头开始
- (UIBezierPath *)arrowDownPath{
    _arrowDownPath = [UIBezierPath bezierPath];
    [_arrowDownPath moveToPoint:CGPointMake(arrowPointX, arrowPointY+kSpacing)];
    [_arrowDownPath addLineToPoint:CGPointMake(halfSquare,linePoinY+arrowLineH+kSpacing)];
    [_arrowDownPath addLineToPoint:CGPointMake(arrowPointX+arrowTW, arrowPointY+kSpacing)];
    return _arrowDownPath;
}
//箭头开始
- (UIBezierPath *)arrowMidtPath{
    
    _arrowMidtPath = [UIBezierPath bezierPath];
    [_arrowMidtPath moveToPoint:CGPointMake(midPointX, halfSquare)];
    [_arrowMidtPath addLineToPoint:CGPointMake(midPointX+lineW/2,halfSquare-kSpacing*2)];
    [_arrowMidtPath addLineToPoint:CGPointMake(midPointX+lineW, halfSquare)];
    return _arrowMidtPath;
}
//直线
- (UIBezierPath *)arrowEndPath{
    _arrowEndPath = [UIBezierPath bezierPath];
    [_arrowEndPath moveToPoint:CGPointMake(midPointX, halfSquare)];
    [_arrowEndPath addLineToPoint:CGPointMake(halfSquare, halfSquare)];
    [_arrowEndPath addLineToPoint:CGPointMake(midPointX+lineW, halfSquare)];
    return _arrowEndPath;
}
//竖线
- (UIBezierPath *)verticalLineStartPath{
    _verticalLineStartPath = [UIBezierPath bezierPath];
    [_verticalLineStartPath moveToPoint:CGPointMake(halfSquare, verticalLinePointX)];
    [_verticalLineStartPath addLineToPoint:CGPointMake(halfSquare, verticalLinePointX+arrowLineH)];
    return _verticalLineStartPath;
}
- (UIBezierPath *)verticalLineEndPath{
    _verticalLineEndPath = [UIBezierPath bezierPath];
    [_verticalLineEndPath moveToPoint:CGPointMake(halfSquare, verticalLineEndPointX)];
    [_verticalLineEndPath addLineToPoint:CGPointMake(halfSquare, verticalLineEndPointX)];
    return _verticalLineEndPath;
}

- (UIBezierPath *)succesPath{
    
    _succesPath = [UIBezierPath bezierPath];
    
    CGFloat SW = CGRectGetWidth(self.viewRect);
    
    CGFloat successPoint1X = SW*successPoint1ScaleX;
    CGFloat successPoint1Y = SW*successPoint1ScaleY;

    CGFloat successPoint2X = SW*successPoint2ScaleX;
    CGFloat successPoint2Y = SW*successPoint2ScaleY;

    CGFloat successPoint3X = SW*successPoint3ScaleX;
    CGFloat successPoint3Y = SW*successPoint3ScaleY;

    [_succesPath moveToPoint:CGPointMake(successPoint1X, successPoint1Y)];
    [_succesPath addLineToPoint:CGPointMake(successPoint2X, successPoint2Y)];
    [_succesPath addLineToPoint:CGPointMake(successPoint3X, successPoint3Y)];
    
    return _succesPath;
}

- (UIBezierPath *)getCirclePathWithProgress:(CGFloat)progress
{
    
    CGFloat squareW = CGRectGetWidth(self.viewRect)/2;
    CGFloat squareH = CGRectGetHeight(self.viewRect)/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(squareW, squareH)
                                                   radius:squareW
                                               startAngle: - M_PI_2
                                                 endAngle: (M_PI * 2) * progress - M_PI_2
                                                clockwise:YES];
    return path;
}

- (UIBezierPath *)getWavePathWithOffset:(CGFloat)offset
                             WaveHeight:(CGFloat)height
                          WaveCurvature:(CGFloat)curvature{
    
    waveHeight = height;
    
    CGFloat SW = CGRectGetWidth(self.viewRect);
    
    _arrowWavePath = [UIBezierPath bezierPath];
    [_arrowWavePath moveToPoint:CGPointMake(midPointX, SW/2)];
    CGFloat y = 0;
    for (CGFloat x = midPointX; x <= midPointX+lineW ; x++) {
        y = height * sinf(curvature * x + offset )+SW/2;
        [_arrowWavePath addLineToPoint:CGPointMake(x, y)];
    }
    return _arrowWavePath;
}

- (CASpringAnimation *)getProgressAnimationShow:(BOOL)isShow{

    CASpringAnimation *progressAnimation = [CASpringAnimation animationWithKeyPath:keyPath_Scale];
    progressAnimation.fromValue = isShow==YES?@.3:@1;
    progressAnimation.toValue     = isShow==YES?@1:@.5;
    progressAnimation.mass = 1;
    progressAnimation.stiffness = 100;
    progressAnimation.damping = 10;
    progressAnimation.initialVelocity = 0;
    progressAnimation.duration = 1.5;
    return progressAnimation;
}

- (CAAnimationGroup *)getLineToSuccessAnimationWithValues:(NSArray *)values{
    
    CAKeyframeAnimation *lineToSuccessAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath_Path];
    lineToSuccessAnimation.values = values;
    lineToSuccessAnimation.duration = .6;
    lineToSuccessAnimation.removedOnCompletion = NO;
    lineToSuccessAnimation.fillMode  = kCAFillModeForwards;
    lineToSuccessAnimation.beginTime = 0;
    lineToSuccessAnimation.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CASpringAnimation *successSpring = [CASpringAnimation animationWithKeyPath:keyPath_Scale];
    successSpring.fromValue = @1.3;
    successSpring.toValue = @1;
    successSpring.damping = 10;
    successSpring.mass = 1;
    successSpring.initialVelocity = 0;
    successSpring.beginTime= 0.60;
    successSpring.removedOnCompletion = NO;
    successSpring.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[lineToSuccessAnimation,successSpring];
    group.duration  = 2;
    group.removedOnCompletion = NO;
    group.fillMode  = kCAFillModeForwards;
    
    return group;
}

- (CGRect)getProgressRect{
    CGFloat SW = CGRectGetWidth(self.viewRect);
    return CGRectMake(midPointX, SW/2+waveHeight*2, lineW, SW/4);
}


@end
