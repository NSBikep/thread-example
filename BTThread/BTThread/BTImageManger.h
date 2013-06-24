//
//  BTImageManger.h
//  BTThread
//
//  Created by 王 浩宇 on 13-6-21.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTImageManger : NSObject



@property (nonatomic,assign)BOOL  isloading;
@property (nonatomic,assign)BOOL  isAutoCancelRequest;
- (void)imageForURL:(NSURL *)url completeBlock:(void (^)(UIImage *image, NSURL *url))complete;

- (void)cancelRequest;

@end
