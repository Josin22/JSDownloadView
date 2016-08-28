//
//  ViewController.m
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "ViewController.h"
#import "JSDownloadView.h"

@interface ViewController ()
{
    NSTimer *_timer;
    double _timeCount;
    CGFloat progress;
}
@property (nonatomic, strong) JSDownloadView *downloadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XNColor(41, 158, 239, 1);
    
    [self.view addSubview:({
        JSDownloadView *downloadView = [[JSDownloadView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-50, CGRectGetHeight(self.view.frame)/2-50, 100, 100)];
        downloadView.didClickBlock = ^{
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
        };
        downloadView.progressWidth = 4;
        self.downloadView = downloadView;
        self.downloadView;
    })];
    
    _timeCount = 50.0;
    progress = 0.0;
    
}


// 模拟网络请求数据进度
- (void)timeDown{
    _timeCount -= 1;
    progress += 0.02;
    self.downloadView.progress  = progress;
    
    if (_timeCount <= 0) {
        _timeCount = 50.0;
        progress = 0.0;
        [_timer invalidate];
    }
}

@end
