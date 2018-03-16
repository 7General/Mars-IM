//
//  C2CpushTask.m
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "C2CpushTask.h"

@implementation C2CpushTask

+ (instancetype)taskWithMessageId:(int64_t)msgId {
    return [[[self class] alloc] initWithMessageId:msgId];
}

- (instancetype)initWithMessageId:(int64_t)msgId {
    if (self = [super initAll:ChannelType_LongConn AndCmdId:1006]) {
        self.send_only = true;
        self.retry_count = 0;
        C2CPushResponse *response = [C2CPushResponse new];
        response.msgid = msgId;
        self.requestData = [response data];
    }
    return self;
}
@end
