//
//  ViewController.m
//  JSDownloadView
//
//  Created by 乔同新 on 16/8/27.
//  Copyright © 2016年 乔同新. All rights reserved.
//https://github.com/Josin22/JSDownloadView

#import "ViewController.h"
#import "JSDownloadView.h"
#import "JSDownLoadManager.h"

@interface ViewController ()<JSDownloadAnimationDelegate>
{

}
@property (nonatomic, strong) JSDownloadView *downloadView;

@property (nonatomic, strong) JSDownLoadManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self addSubView];
    
 }

- (void)addSubView{
    
    [self.view addSubview:({
        JSDownloadView *downloadView = [[JSDownloadView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-50, CGRectGetHeight(self.view.frame)/2-50, 100, 100)];
        downloadView.delegate = self;
        downloadView.progressWidth = 4;
        self.downloadView = downloadView;
    })];

}

- (void)initData{
    
    self.title  = @"JSDownloadAnimation";
    self.view.backgroundColor = XNColor(41, 158, 239, 1);

}

- (JSDownLoadManager *)manager{
    
    if (!_manager) {
        _manager = [[JSDownLoadManager alloc] init];
    }
    return _manager;
}


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

#pragma mark -  animation delegate

- (void)animationStart{
    
    [self downTask];
}

- (void)animationSuspend{
    
    [self.manager suspend];
}

- (void)animationEnd{
    
    
}


@end
