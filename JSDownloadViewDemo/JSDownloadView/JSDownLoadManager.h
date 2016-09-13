//
//  JSDownLoadManage.h
//  JSDownloadViewDemo
//
//  Created by 乔同新 on 16/9/12.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JSDownloadProgressBlock)(NSProgress * downloadProgress);

typedef NSURL *(^JSDownloadPath)(NSURL * targetPath, NSURLResponse * response);

typedef void(^JSDownloadCompletionBlock)(NSURLResponse * response, NSURL * filePath, NSError * error);

@interface JSDownLoadManager : NSObject
/**
 *  下载
 *
 *  @param url                                       url
 *  @param downloadProgressBlock    下载进度
 *  @param downloadPath                    下载路径
 *  @param downloadCompletionBlock 下载成功
 */
- (void)downloadWithURL:(NSString *)url
               progress:(JSDownloadProgressBlock)downloadProgressBlock
                   path:(JSDownloadPath)downloadPath
             completion:(JSDownloadCompletionBlock)downloadCompletionBlock;
/**
 *  取消
 */
- (void)cancel;
/**
 *  开始
 */
- (void)resume;
/**
 *  暂停
 */
- (void)suspend;

@end
