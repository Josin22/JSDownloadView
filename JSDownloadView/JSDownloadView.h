//
//  JSDownloadView.h
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//https://github.com/Josin22/JSDownloadView

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define XNColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@protocol JSDownloadAnimationDelegate <NSObject>

@required
- (void)animationStart;

@optional
- (void)animationSuspend;

- (void)animationEnd;

@end

@interface JSDownloadView : UIView
/**
 *  进度:0~1
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  进度宽
 */
@property (nonatomic, assign) CGFloat progressWidth;
/**
 *  是否下载成功
 */
@property (nonatomic, assign) BOOL isSuccess;
/**
 *  委托代理
 */
@property (nonatomic, weak) id<JSDownloadAnimationDelegate> delegate;

@end
