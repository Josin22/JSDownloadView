//
//  JSAnimationService.h
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/30.
//  Copyright © 2016年 乔同新. All rights reserved.
//https://github.com/Josin22/JSDownloadView


#import <UIKit/UIKit.h>

/*  animation key  */

static NSString  * kLineToPointUpAnimationKey = @"kLineToPointUpAnimationKey";

static NSString  * kArrowToLineAnimationKey = @"kArrowToLineAnimationKey";

static NSString  * kProgressAnimationKey = @"kProgressAnimationKey";

static NSString  * kSuccessAnimationKey = @"kSuccessAnimationKey";

@interface JSAnimationService : NSObject

@property (nonatomic , assign) CGRect viewRect;

@property (nonatomic, strong) UIBezierPath *progressPath;
/**    关键帧    **/
@property (nonatomic, strong) UIBezierPath *arrowStartPath;
@property (nonatomic, strong) UIBezierPath *arrowDownPath;
@property (nonatomic, strong) UIBezierPath *arrowMidtPath;
@property (nonatomic, strong) UIBezierPath *arrowEndPath;

@property (nonatomic, strong) UIBezierPath *arrowWavePath;

@property (nonatomic, strong) UIBezierPath *verticalLineStartPath;
@property (nonatomic, strong) UIBezierPath *verticalLineEndPath;

@property (nonatomic, strong) UIBezierPath *succesPath;
/**
 *  线到点动画
 *
 *  @param values 关键帧
 *
 *  @return 动画组
 */
- (CAAnimationGroup *)getLineToPointUpAnimationWithValues:(NSArray *)values;
/**
 *  箭头到线的动画
 *
 *  @param values 关键帧
 *
 *  @return 动画组
 */
- (CAAnimationGroup *)getArrowToLineAnimationWithValues:(NSArray *)values;
/**
 *  获取圆圈进度
 *
 *  @param progress 当前进度值
 *
 *  @return path
 */
- (UIBezierPath *)getCirclePathWithProgress:(CGFloat)progress;
/**
 *  绘制波浪线
 *
 *  @param offset  偏移量
 *  @param height    浪高
 *  @param curvature 浪曲
 *
 *  @return path
 */
- (UIBezierPath *)getWavePathWithOffset:(CGFloat)offset
                             WaveHeight:(CGFloat)height
                          WaveCurvature:(CGFloat)curvature;
/**
 *  是否显示进度label
 *
 *  @param isShow YES/NO
 *
 *  @return 弹性动画
 */
- (CASpringAnimation *)getProgressAnimationShow:(BOOL)isShow;
/**
 *  线变成功动画
 *
 *  @param values 关键帧
 *
 *  @return 动画组
 */
- (CAAnimationGroup *)getLineToSuccessAnimationWithValues:(NSArray *)values;
/**
 *  获取进度label Rect
 *
 *  @return Rect
 */
- (CGRect)getProgressRect;

@end
