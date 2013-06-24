//
//  BTImageManger.m
//  BTThread
//
//  Created by 王 浩宇 on 13-6-21.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import "BTImageManger.h"
#import "BTCache.h"
#import "BTURLRequestOperation.h"
#import <objc/runtime.h>

static char kBTImageRequestOperationObjectKey = 1;

@interface BTImageManger (runTime)

@property (nonatomic, retain) BTURLRequestOperation *imageRequestOperation;

@end

@implementation BTImageManger (runTime)

@dynamic imageRequestOperation;

- (BTURLRequestOperation *)imageRequestOperation {
    return (BTURLRequestOperation *)objc_getAssociatedObject(self, &kBTImageRequestOperationObjectKey);
}

- (void)setImageRequestOperation:(BTURLRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kBTImageRequestOperationObjectKey, imageRequestOperation,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end





@interface BTImageManger ()

@property (nonatomic,retain)NSURL *requestURL;

@end




@implementation BTImageManger

@synthesize requestURL;

@synthesize isloading,isAutoCancelRequest;


#pragma mark ————————————————————————
#pragma mark class Method

//得到下载的队列
+ (NSOperationQueue *)sharedImageRequestOperationQueue {
    static NSOperationQueue *__imageRequestOperationQueue = nil;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        __imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [__imageRequestOperationQueue setMaxConcurrentOperationCount:3];
    });
    
    return __imageRequestOperationQueue;
}

- (void)dealloc{
    self.requestURL = nil;
    [super dealloc];
}

- (void)imageForURL:(NSURL *)url completeBlock:(void (^)(UIImage *image, NSURL *url))complete;{
    if([self.requestURL isEqual:url]){
        return;
    }else{
        [self cancelRequest];
        self.requestURL = url;
        if([url isEqual:[NSURL URLWithString:@"https://d2rfichhc2fb9n.cloudfront.net/image/4/RFiYCGPi-cvRoOVXboh18v-TLS4W6qfhDF6yh5NJbNcX9oExjqPjjKe6YTJUuVBbsQf17DejEOLLH--BiN753co1bQbaLl3EjO4tyeQQB9xBpVhJpC3MDYBf4tgv4CrAzWhE2iezRldWTKHSs7XSjQIB4_o"]]){
            NSLog(@"发出请求");
        }
        [[BTCache sharedCache] imageForURL:url completionBlock:^(UIImage *image, NSURL *url) {
            if ([self.requestURL isEqual:url]) {
                if (image&&complete) {
                    if([url isEqual:[NSURL URLWithString:@"https://d2rfichhc2fb9n.cloudfront.net/image/4/RFiYCGPi-cvRoOVXboh18v-TLS4W6qfhDF6yh5NJbNcX9oExjqPjjKe6YTJUuVBbsQf17DejEOLLH--BiN753co1bQbaLl3EjO4tyeQQB9xBpVhJpC3MDYBf4tgv4CrAzWhE2iezRldWTKHSs7XSjQIB4_o"]]){
                        NSLog(@"完成");
                    }
                    complete(image,self.requestURL);
                } else {
                    //TODO: request
                    [self sendRequestWithCompleteBlock:complete];
                }
            }
        }];
    }
}

//cancel request
- (void)cancelRequest{
    //去掉从本地读取的request
    [[BTCache sharedCache] cancelImageForURL:self.requestURL];
    
    //去掉从网络读取的request
    if(self.isAutoCancelRequest){
        BTURLRequestOperation *op = self.imageRequestOperation;
        if(op){
            [op cancel];
            self.imageRequestOperation = nil;
        }
    }
}

- (BOOL)isloading{//是否存在网络的请求
    return !!self.imageRequestOperation;
}

- (void)sendRequestWithCompleteBlock:(void (^)(UIImage *image ,NSURL *url))complete{
    //NSLog(@"发请求");
    NSURL *url = self.requestURL;    
    BTURLRequestOperationCompleteBlock completeBlock = ^(BTURLRequestOperation *op){
        BTURLImageResponse *response = op.urlResponse;
        UIImage *image = response.image;
        NSURL *url = op.request.URL;
        if(url&&image){
            [[BTCache sharedCache] setImage:image forURL:[op.request URL]];
            if(url){
                if([url isEqual:self.requestURL]){
                    self.imageRequestOperation = nil;
                    if(complete&&image){
                        complete(image,url);
                    }
                }
            }
        }
    };
    
    BTURLRequestOperationStartBlock startBlock = ^(BTURLRequestOperation *op){
        //NSLog(@"开始请求 op =  %@",op);
    };
    
    
    BTURLRequestOperation *operation = [[BTURLRequestOperation alloc] initWithURL:url start:startBlock cancel:nil complete:completeBlock failed:nil];
    operation.urlResponse = [[[BTURLImageResponse alloc] init] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityNormal];
    self.imageRequestOperation = operation;
    [[[self class] sharedImageRequestOperationQueue] addOperation:operation];
    [operation release];
    
}

@end
