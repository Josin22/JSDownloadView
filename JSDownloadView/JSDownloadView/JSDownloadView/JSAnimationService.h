//
//  JSAnimationService.h
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/30.
//  Copyright © 2016年 乔同新. All rights reserved.
//


#import <UIKit/UIKit.h>

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

- (CAAnimationGroup *)getLineToPointUpAnimationWithValues:(NSArray *)values;

- (CAAnimationGroup *)getArrowToLineAnimationWithValues:(NSArray *)values;

- (UIBezierPath *)getCirclePathWithProgress:(CGFloat)progress;

- (UIBezierPath *)getWavePathWithOffset:(CGFloat)offset
                             WaveHeight:(CGFloat)height
                          WaveCurvature:(CGFloat)curvature;

- (CASpringAnimation *)getProgressAnimationShow:(BOOL)isShow;

- (CAAnimationGroup *)getLineToSuccessAnimationWithValues:(NSArray *)values;

- (CGRect)getProgressRect;

@end
