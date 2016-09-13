[![header](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download_icon.png)](http://qiaotongxin.cc)
# JSDownloadView
[![GitHub license](https://img.shields.io/badge/platform-ios-green.svg
)](https://github.com/josin22/JSDownloadView)
[![GitHub license](https://img.shields.io/badge/license-MIT-green.svg)](https://raw.githubusercontent.com/josin22/JSDownloadView/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-1.1.0-red.svg)](https://github.com/josin22/JSDownloadView)
[![CocoaPods Compatible](https://img.shields.io/badge/build-passing-green.svg)](https://github.com/josin22/JSDownloadView)


# 安装
支持pod 安装

	pod 'JSDownloadView'
	

# 设计灵感
设计此效果的作者 [Nick](https://material.uplabs.com/nickbuturisvili);
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download.gif)


# 开始之前你需要了解的
先上一张CAAnimation层次图:
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/caanimation.png)

图上只是一些类的常用属性,后边更多代码会讲到.

# 怎样分解动画

关于分解gif,其实用mac 预览 开发gif文件,就可以看到所有帧的图片.
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/fenjie_download.png)

选取其中几张动画节点的图片存好备用.比如:
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download1.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download2.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download3.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download4.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download5.png)

考虑到适配问题service类里已经提取好了.

# 怎样连贯动画

连贯动画是展示你做的效果流畅不流畅,看着舒服不舒服的能力.其实我是也是尝试很多遍,让很多人看了这个效果,有说别扭的咱就改,咋顺咋来.所以让动画连贯起来尤为重要.

第一,就是要动画节点要选准确,定位好动画与动画的衔接处.
第二,让动画结束时,恢复自然状态,而不是默认状态.尽量不要有太大的差异和不规整的地方
第三,使用组合动画,掐好时间节点.

简单的就说就说这么多,下面我们开始演练代码~~~~~~

# 代码实现 

## 基本实现想法

~~1.自定义UIControl类,因为它本身就是UIView子类,做点击事件的View再好不过.(另一种方式用block点击回调)~~

1.使用代理,继承UIView.

2.点击区域是否在圆内判断

3.两个CAShapeLayer圆环+(一个CAShapeLayer箭头和CAShapeLayer竖线)组合成箭头+label


4.一个service类管理创建所用到的path和animation


## service 类
### service属性
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
### service方法
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
### service key
	/*  animation key  */
	
	static NSString  * kLineToPointUpAnimationKey = @"kLineToPointUpAnimationKey";
	
	static NSString  * kArrowToLineAnimationKey = @"kArrowToLineAnimationKey";
	
	static NSString  * kProgressAnimationKey = @"kProgressAnimationKey";
	
	static NSString  * kSuccessAnimationKey = @"kSuccessAnimationKey";
### service 比例系数
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
	
## download 类
### 属性
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
### 所有方法预览
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download_all.png)


### 代理

	@protocol JSDownloadAnimationDelegate <NSObject>
	
	@required
	- (void)animationStart;
	
	@optional
	- (void)animationSuspend;
	
	- (void)animationEnd;
	
	@end


方法比较多,在这不一一展示了,有感兴趣的童鞋可以直接去[github下载](https://github.com/Josin22/JSDownloadView),记得点个星星哦~~~😜

## 调用
使用全真网络下载

	- (void)downTask{
	
	    //1M
	//    NSString*url = @"http://obh6cwxkc.bkt.clouddn.com/146621166967.jpg";
	    //26M
	    NSString*url = @"http://obh6cwxkc.bkt.clouddn.com/iStat%20Menus.app.zip";
	    //文件比较大  200M
	//    NSString*url = @"http://obh6cwxkc.bkt.clouddn.com/Command_Line_Tools_OS_X_10.11_for_Xcode_7.3.1.dmg";
	    
	    [self.manager downloadWithURL:url
	                         progress:^(NSProgress *downloadProgress) {
	                        
	                             dispatch_async(dispatch_get_main_queue(), ^{
	                                 NSString *progressString  = [NSString stringWithFormat:@"%.2f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
	                                 self.downloadView.progress = progressString.floatValue;
	                             });
	                             
	                         }
	                             path:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
	                                 //
	                                 NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	                                 NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
	                                 return [NSURL fileURLWithPath:path];
	                             }
	                       completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
	                           //此时已在主线程
	                           self.downloadView.isSuccess = YES;
	                           NSString *path = [filePath path];
	                           NSLog(@"************文件路径:%@",path);
	                       }];
	}


# 最终效果

现实与理想还是有些差距,希望不是很大,在此分享一下自己研究的经验,有任何问题都可以Issues我,

![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadViewDemo/Source/download_animation.gif)


# Release notes

Version 1.1.0

* 使用代理委托,取消继承uicontro,利用代理观察事件触发
* 优化动画,抽离波浪动画,单独利用定时器动画.
* 真实模拟网络数据下载


Version 1.0

* 1.0版下载动画


# MIT License
MIT License

Copyright (c) 2016 乔同X

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.




