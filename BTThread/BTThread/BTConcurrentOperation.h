//
//  BTConcurrentOperation.h
//  BTThread
//
//  Created by Gary on 13-4-2.
//  Copyright (c) 2013年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BTConcurrentOperation : NSOperation
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSSet *runLoopModes;
@end
