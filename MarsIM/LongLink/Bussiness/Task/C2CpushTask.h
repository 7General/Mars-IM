//
//  C2CpushTask.h
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "CGITask.h"
#import "C2Cpush.pbobjc.h"

@interface C2CpushTask : CGITask

+ (instancetype)taskWithMessageId:(int64_t)msgId;
- (instancetype)initWithMessageId:(int64_t)msgId;
@end
