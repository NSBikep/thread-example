//
//  BTImageManger.m
//  BTThread
//
//  Created by 王 浩宇 on 13-6-21.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import "BTImageManger.h"
#import "BTCache.h"

@implementation BTImageManger
//
//+ (void)initialize{
//    
//}
//
//+ (void)

+ (id)imageForURL:(NSURL *)url completeBlock:(void (^)(UIImage *image, NSURL *url))complete;{
    
    
    BTImageManger *manager = [[[BTImageManger alloc] init] autorelease];
#warning ..这个位置还没看嗯，Neo
    [[BTCache sharedCache] cancelImageForURL:url];
    
    return manager;
//    [[BTCache sharedCache] cancelImageForURL:url];
//    [self cancelImageRequestOperation];
//    self.requestURL = url;
//    
//    self.isLoaded = NO;
//    self.image = nil;
//    [[BTCache sharedCache] imageForURL:url completionBlock:^(UIImage *image, NSURL *url) {
//        if ([self.requestURL isEqual:url]) {
//            if (image) {
//                self.image = image;
//            } else {
//                [self sendRequestDalayed];
//            }
//        }
//    }];
    return self;
}


@end
