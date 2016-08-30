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
    CGFloat _progress;
}
@property (nonatomic, strong) JSDownloadView *downloadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"JSDownloadAnimation";
    self.view.backgroundColor = XNColor(41, 158, 239, 1);
    
    [self initData];
    
    [self.view addSubview:({
        JSDownloadView *downloadView = [[JSDownloadView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-50, CGRectGetHeight(self.view.frame)/2-50, 100, 100)];
//        downloadView.didClickBlock = ^{
//            
//            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
//        };
        [downloadView addTarget:self action:@selector(updateProgress) forControlEvents:UIControlEventTouchUpInside];
        downloadView.progressWidth = 4;
        self.downloadView = downloadView;
        self.downloadView;
    })];

}

- (void)initData{
    _timeCount = 200.0;
    _progress = 0.0;
}

// 模拟网络请求数据进度
- (void)timeDown{
    _timeCount -= 1;
    _progress += 0.005;
    self.downloadView.progress  = _progress;
    
    if (_timeCount <= 0) {
        
        [self initData];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)updateProgress{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
}

@end
