//
//  JSDownLoadManage.m
//  JSDownloadViewDemo
//
//  Created by 乔同新 on 16/9/12.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSDownLoadManager.h"
#import "AFNetworking.h"

@interface JSDownLoadManager ()
{
    NSURLSessionDownloadTask *_downloadTask;
}
@end

@implementation JSDownLoadManager

- (void)downloadWithURL:(NSString *)url
               progress:(JSDownloadProgressBlock)downloadProgressBlock
                   path:(JSDownloadPath)downloadPath
             completion:(JSDownloadCompletionBlock)downloadCompletionBlock{
 
    
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    _downloadTask = [manager downloadTaskWithRequest:request
                                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                                downloadProgressBlock(downloadProgress);
                                            }
                                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                             return downloadPath(targetPath,response);
                                         }
                                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                       downloadCompletionBlock(response,filePath,error);
                                   }];

    [self resume];
}

- (void)cancel{
    
    [_downloadTask cancel];
}

- (void)resume{
    
    [_downloadTask resume];
}

- (void)suspend{
    
    [_downloadTask suspend];
}

@end
