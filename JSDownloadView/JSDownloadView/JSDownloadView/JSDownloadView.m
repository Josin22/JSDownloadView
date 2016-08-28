//
//  JSDownloadView.m
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSDownloadView.h"


//箭头比例
static const double arrowHScale = 130.00/250.00;

//箭头头部高比例
static const double arrowTWScale = 96.00/250.00;
static const double arrowTHScale = 50.00/250.00;

//
static const double lineWScale = 176.00/250.00;

static const double pointSpacingScale = 16.00/250.00;

static const  NSInteger  kSpacing = 2;

@interface JSDownloadView ()
{
    UIBezierPath *_progressPath;
    
    UIBezierPath *_arrowStartPath;
    UIBezierPath *_arrowDownPath;
    UIBezierPath *_arrowMidtPath;
    UIBezierPath *_arrowEndPath;
    
    UIBezierPath *_verticalLineStartPath;
    UIBezierPath *_verticalLineEndPath;
    
}
//进度圈
@property (nonatomic, strong) CAShapeLayer *realCircleLayer;
//底圈
@property (nonatomic, strong) CAShapeLayer *maskCircleLayer;
//箭头
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
//竖线
@property (nonatomic, strong) CAShapeLayer *verticalLineLayer;

@end

@implementation JSDownloadView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.progressWidth = 4;
    
    
    [self.layer addSublayer:self.maskCircleLayer];
    [self.layer addSublayer:self.realCircleLayer];
    [self.layer addSublayer:self.arrowLayer];
    [self.layer addSublayer:self.verticalLineLayer];
    
    [self setPaths];

}


#pragma mark - Lazy View

- (CAShapeLayer *)maskCircleLayer{
    
    if (!_maskCircleLayer) {
        _maskCircleLayer = [self getOriginLayer];
        _maskCircleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self bounds]];
        _maskCircleLayer.path = path.CGPath;
    }
    return _maskCircleLayer;
}


- (CAShapeLayer *)realCircleLayer{
    
    if (!_realCircleLayer) {
        _realCircleLayer = [self getOriginLayer];
        _realCircleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        _realCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    
    return _realCircleLayer;
}

- (CAShapeLayer *)getOriginLayer{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = [self bounds];
    layer.lineWidth = self.progressWidth;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    return layer;
}

- (CAShapeLayer *)arrowLayer{
    
    if (!_arrowLayer) {
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.frame = [self bounds];
        _arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.lineWidth = self.progressWidth-1;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.lineJoin = kCALineJoinRound;
    }
    return _arrowLayer;
}

- (CAShapeLayer *)verticalLineLayer{
    
    if (!_verticalLineLayer) {
        _verticalLineLayer = [CAShapeLayer layer];
        _verticalLineLayer.frame = [self bounds];
        _verticalLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _verticalLineLayer.lineCap = kCALineCapRound;
        _verticalLineLayer.lineWidth = self.progressWidth-1;
        _verticalLineLayer.fillColor = [UIColor clearColor].CGColor;
        
    }
    return _verticalLineLayer;
}

#pragma mark - Method


- (void)setProgressWidth:(CGFloat)progressWidth{
    
    _progressWidth = progressWidth;
    
    self.realCircleLayer.lineWidth = progressWidth;
    self.maskCircleLayer.lineWidth = progressWidth;
    self.verticalLineLayer.lineWidth = progressWidth-1;
    self.arrowLayer.lineWidth = progressWidth-1;
}


- (void)setPaths{
    
    CGFloat SW = CGRectGetWidth(self.frame);
    CGFloat halfSquare = SW/2;
    
    CGFloat arrowLineH = SW * arrowHScale;
    
    CGFloat arrowTH = SW * arrowTHScale;
    CGFloat arrowTW = SW * arrowTWScale;
    
    CGFloat linePoinY = (SW-arrowLineH)/2;
    CGFloat arrowPointX = (SW-arrowTW)/2;
    CGFloat arrowPointY = SW-(linePoinY+arrowTH);

    //箭头开始
    _arrowStartPath = [UIBezierPath bezierPath];
    [_arrowStartPath moveToPoint:CGPointMake(arrowPointX, arrowPointY)];
    [_arrowStartPath addLineToPoint:CGPointMake(halfSquare,linePoinY+arrowLineH)];
    [_arrowStartPath addLineToPoint:CGPointMake(arrowPointX+arrowTW, arrowPointY)];
    _arrowLayer.path = _arrowStartPath.CGPath;
    
    //箭头下降
    _arrowDownPath = [UIBezierPath bezierPath];
    [_arrowDownPath moveToPoint:CGPointMake(arrowPointX, arrowPointY+kSpacing)];
    [_arrowDownPath addLineToPoint:CGPointMake(halfSquare,linePoinY+arrowLineH+kSpacing)];
    [_arrowDownPath addLineToPoint:CGPointMake(arrowPointX+arrowTW, arrowPointY+kSpacing)];
    
    CGFloat lineW = SW * lineWScale;
    
    CGFloat midPointX = (SW-lineW)/2;
    //反弹
    _arrowMidtPath = [UIBezierPath bezierPath];
    [_arrowMidtPath moveToPoint:CGPointMake(midPointX, halfSquare)];
    [_arrowMidtPath addLineToPoint:CGPointMake(midPointX+lineW/2,halfSquare-kSpacing*2)];
    [_arrowMidtPath addLineToPoint:CGPointMake(midPointX+lineW, halfSquare)];
    //直线
    _arrowEndPath = [UIBezierPath bezierPath];
    [_arrowEndPath moveToPoint:CGPointMake(midPointX, halfSquare)];
    [_arrowEndPath addLineToPoint:CGPointMake(halfSquare, halfSquare)];
    [_arrowEndPath addLineToPoint:CGPointMake(midPointX+lineW, halfSquare)];
    
    CGFloat verticalLinePointX = (SW-arrowLineH)/2;
    
    //竖线
    _verticalLineStartPath = [UIBezierPath bezierPath];
    [_verticalLineStartPath moveToPoint:CGPointMake(halfSquare, verticalLinePointX)];
    [_verticalLineStartPath addLineToPoint:CGPointMake(halfSquare, verticalLinePointX+arrowLineH)];
    _verticalLineLayer.path = _verticalLineStartPath.CGPath;
    
    CGFloat pointSpacing = pointSpacingScale *SW;
    CGFloat verticalLineEndPointX = halfSquare-pointSpacing;
    //
    _verticalLineEndPath = [UIBezierPath bezierPath];
    [_verticalLineEndPath moveToPoint:CGPointMake(halfSquare, verticalLineEndPointX)];
    [_verticalLineEndPath addLineToPoint:CGPointMake(halfSquare, verticalLineEndPointX)];

}

- (void)setProgress:(CGFloat)progress{
    
    _progress  = progress;
    
    CGFloat squareW = CGRectGetWidth(self.bounds)/2;
    CGFloat squareH = CGRectGetHeight(self.bounds)/2;
    
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(squareW, squareH)
                                                   radius:squareW
                                               startAngle: - M_PI_2
                                                 endAngle: (M_PI * 2) * self.progress - M_PI_2
                                                clockwise:YES];
    self.realCircleLayer.path = _progressPath.CGPath;
    
    

}

- (void)clearAnimations{
    
    [_verticalLineLayer removeAllAnimations];
    [_arrowLayer removeAllAnimations];
    if (!_progressPath.empty) {
        [_progressPath removeAllPoints];
        _realCircleLayer.path = _progressPath.CGPath;
    }
}

#pragma mark - Animation

- (void)startAnimationBeforeCircle{
    
    CAKeyframeAnimation *lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    lineAnimation.values = @[(__bridge id)_verticalLineStartPath.CGPath,(__bridge id)_verticalLineEndPath.CGPath];
    lineAnimation.keyTimes = @[@0,@.15];
    lineAnimation.beginTime= 0.0;
    
    CASpringAnimation *lineUpAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    lineUpAnimation.toValue = @6;
    lineUpAnimation.damping = 10;
    lineUpAnimation.mass = 1;
    lineUpAnimation.initialVelocity = 0;
    lineUpAnimation.duration = lineUpAnimation.settlingDuration;
    lineUpAnimation.beginTime= 0.50;
    lineUpAnimation.removedOnCompletion = NO;
    lineUpAnimation.fillMode = kCAFillModeForwards;
    // 线->点 and 上弹
    CAAnimationGroup *lineGroup = [CAAnimationGroup animation];
    lineGroup.delegate = self;
    lineGroup.animations = @[lineAnimation,lineUpAnimation];
    lineGroup.duration = 2;
    lineGroup.repeatCount = 1;
    lineGroup.removedOnCompletion = NO;
    lineGroup.fillMode = kCAFillModeForwards;
    lineGroup.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_verticalLineLayer addAnimation:lineGroup forKey:@"line"];

    CAKeyframeAnimation *arrowChangeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    arrowChangeAnimation.values = @[(__bridge id)_arrowStartPath.CGPath,(__bridge id)_arrowDownPath.CGPath,(__bridge id)_arrowMidtPath.CGPath,(__bridge id)_arrowEndPath.CGPath];
    arrowChangeAnimation.keyTimes = @[@0,@.15,@.25,@.3];
    //箭头形变直线
    CAAnimationGroup *arrowGroup = [CAAnimationGroup animation];
    arrowGroup.animations = @[arrowChangeAnimation];
    arrowGroup.duration  = 2;
    arrowGroup.repeatCount  = 1;
    arrowGroup.removedOnCompletion = NO;
    arrowGroup.fillMode = kCAFillModeForwards;
    arrowGroup.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_arrowLayer addAnimation:arrowGroup forKey:@"changepath"];
    
}

#pragma mark - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([_verticalLineLayer animationForKey:@"line"]==anim && flag)
    {
        
//        self.arrowLayer.lineCap = kCALineCapSquare;
        
        if (self.didClickBlock) {
            self.didClickBlock();
        }
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch =  [touches anyObject];
    
    if(touch.tapCount == 1 ){

        [self clearAnimations];
        
        [self startAnimationBeforeCircle];
        
    }
    
  }




@end
