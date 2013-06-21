//
//  BTImageManger.h
//  BTThread
//
//  Created by 王 浩宇 on 13-6-21.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTImageManger : NSObject

+ (id)imageForURL:(NSURL *)url completeBlock:(void (^)(UIImage *image, NSURL *url))complete;

@end
