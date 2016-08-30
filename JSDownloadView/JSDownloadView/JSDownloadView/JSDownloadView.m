//
//  JSDownloadView.m
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSDownloadView.h"
#import "JSAnimationService.h"

@interface JSDownloadView ()
{
    id _target;
    SEL _action;
}
//进度圈
@property (nonatomic, strong) CAShapeLayer *realCircleLayer;
//底圈
@property (nonatomic, strong) CAShapeLayer *maskCircleLayer;
//箭头
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
//竖线
@property (nonatomic, strong) CAShapeLayer *verticalLineLayer;

@property (nonatomic, retain) UILabel *progressLabel;

/* 波浪属性 */
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat waveCurvature;
@property (nonatomic, assign) CGFloat waveSpeed;
@property (nonatomic, assign) CGFloat waveHeight;

@property (nonatomic, strong) JSAnimationService *service;

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
    self.waveSpeed = 1.0;
    self.waveCurvature = .25;
    self.waveHeight = 3;
    
    self.service = [[JSAnimationService alloc] init];
    self.service.viewRect = self.frame;
    
    [self setDefaultPaths];

}


#pragma mark - Lazy View

- (CAShapeLayer *)maskCircleLayer{
    
    if (!_maskCircleLayer) {
        _maskCircleLayer = [self getOriginLayer];
        _maskCircleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self bounds]];
        _maskCircleLayer.path = path.CGPath;
        [self.layer addSublayer:self.maskCircleLayer];
    }
    return _maskCircleLayer;
}

- (CAShapeLayer *)realCircleLayer{
    
    if (!_realCircleLayer) {
        _realCircleLayer = [self getOriginLayer];
        _realCircleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        _realCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.realCircleLayer];
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
        [self.layer addSublayer:self.arrowLayer];
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
        [self.layer addSublayer:self.verticalLineLayer];
        
    }
    return _verticalLineLayer;
}

- (UILabel *)progressLabel{
    
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:[self.service getProgressRect]];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        _progressLabel.text = @"00%";
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

#pragma mark - Method

- (void)setProgressWidth:(CGFloat)progressWidth{
    
    _progressWidth = progressWidth;
    
    self.realCircleLayer.lineWidth = progressWidth;
    self.maskCircleLayer.lineWidth = progressWidth;
    self.verticalLineLayer.lineWidth = progressWidth-1;
    self.arrowLayer.lineWidth = progressWidth-1;
}

- (void)setDefaultPaths{

    //箭头开始
    self.arrowLayer.path = self.service.arrowStartPath.CGPath;
    //竖线
    _verticalLineLayer.path = self.service.verticalLineStartPath.CGPath;
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = MAX( MIN(progress, 1.0), 0.0); // keep it between 0 and 1

    //进度
    self.realCircleLayer.path = [self.service getCirclePathWithProgress:_progress].CGPath;

    //浪
    [self wave];
    
    //label
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f",progress];
    
    //结束
    if (_progress == 1.00) {
        //移除label
        [self showProgressLabel:NO];
        //变成对号
        [self showSuccessAnimation];
    }
}

- (void)stopAllAnimations{
    
    [self removeProgressLabel];
    [self.verticalLineLayer removeAllAnimations];
    [self.arrowLayer removeAllAnimations];
    if (!self.service.progressPath.empty) {
        [self.service.progressPath removeAllPoints];
        self.realCircleLayer.path = self.service.progressPath.CGPath;
        
    }
}


#pragma mark - Animation

- (void)startAnimationBeforeCircle{
    
    CAAnimationGroup *lineAnimation = [self.service getLineToPointUpAnimationWithValues:@[
                                                                                          (__bridge id)self.service.verticalLineStartPath.CGPath,
                                                                                          (__bridge id)self.service.verticalLineEndPath.CGPath
                                                                                          ]];
    
    lineAnimation.delegate  = self;
    [self.verticalLineLayer addAnimation:lineAnimation forKey:kLineToPointUpAnimationKey];

    CAAnimationGroup*arrowGroup = [self.service getArrowToLineAnimationWithValues:@[
                                                                                    (__bridge id)self.service.arrowStartPath.CGPath,
                                                                                    (__bridge id)self.service.arrowDownPath.CGPath,
                                                                                    (__bridge id)self.service.arrowMidtPath.CGPath,
                                                                                    (__bridge id)self.service.arrowEndPath.CGPath
                                                                                    ]];
    arrowGroup.delegate  = self;
    [self.arrowLayer addAnimation:arrowGroup forKey:kArrowToLineAnimationKey];
    
}

- (void)removeArrowLayer{
    
    [self.arrowLayer removeFromSuperlayer];
    self.arrowLayer = nil;
}

- (void)removeProgressLabel{
    
    if (self.progressLabel) {
        [self.progressLabel removeFromSuperview];
        [self.progressLabel.layer removeAllAnimations];
        self.progressLabel = nil;
    }
}

- (void)wave{
    
    self.offset += self.waveSpeed;
    
    self.arrowLayer.path = [self.service getWavePathWithOffset:self.offset
                                                    WaveHeight:self.waveHeight
                                                 WaveCurvature:self.waveCurvature].CGPath;
    
}

- (void)showProgressLabel:(BOOL)isShow{
    
    CASpringAnimation *springAnimation = [self.service getProgressAnimationShow:isShow];
    [self.progressLabel.layer addAnimation:springAnimation forKey:kProgressAnimationKey];
    if (!isShow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeProgressLabel];
        });
    }
}

- (void)showSuccessAnimation{
    
//    self.arrowLayer.path = self.service.arrowEndPath.CGPath;
    
//    CAKeyframeAnimation *animation = [self.service getLineToSuccessAnimationWithValues:@[
//                                                                                         (__bridge id)self.service.arrowEndPath.CGPath,
//                                                                                         (__bridge id)self.service.succesPath.CGPath
//                                                                                         ]];
    CAAnimationGroup *group = [self.service getLineToSuccessAnimationWithValues:@[
                                                                                  (__bridge id)self.service.arrowEndPath.CGPath,
                                                                                  (__bridge id)self.service.succesPath.CGPath
                                                                                  ]];
    
    [self.arrowLayer addAnimation:group forKey:kSuccessAnimationKey];
    
}

#pragma mark - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.verticalLineLayer animationForKey:kLineToPointUpAnimationKey]==anim)
    {
/*  block 形式点击回调   */
        
//        if (self.didClickBlock) {
//            self.didClickBlock();
//        }
        
/*  UIcontrol 形式响应   */
        //移除当前arrow
        [self removeArrowLayer];
        //显示progress
        [self showProgressLabel:YES];
        if ([_target respondsToSelector:_action]) {
            [_target performSelectorOnMainThread:_action withObject:nil waitUntilDone:NO];
        }
        
    }
}


#pragma mark - Hit

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    /* 判断点击区域是否在圆内 */
    
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.layer convertPoint:point toLayer:self.maskCircleLayer];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.maskCircleLayer.path];

    if ([path containsPoint:point]) {
        
        [self stopAllAnimations];
        
        [self startAnimationBeforeCircle];
            
    }

}


#pragma mark - override

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    _target  = target;
    _action = action;
}


@end
