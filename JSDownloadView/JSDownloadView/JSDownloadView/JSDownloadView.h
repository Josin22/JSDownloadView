//
//  JSDownloadView.h
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//https://github.com/Josin22/JSDownloadView

#import <UIKit/UIKit.h>

#define XNColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface JSDownloadView : UIControl
/**
 *  进度:0~1
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  进度宽
 */
@property (nonatomic, assign) CGFloat progressWidth;
/**
 *  停止动画
 */
- (void)stopAllAnimations;
/**
 *  block 形式点击回调
 */
//@property (nonatomic, strong) void (^ didClickBlock)();

@end
