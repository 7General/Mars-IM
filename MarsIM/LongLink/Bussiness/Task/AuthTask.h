//
//  AuthTask.h
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "CGITask.h"
#import "Auth.pbobjc.h"

@interface AuthTask : CGITask
+ (instancetype)taskWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void(^)(BOOL success,AuthResponse * response))result;

- (instancetype)initWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void(^)(BOOL success,AuthResponse * response))result;

//- (instancetype)initAll:(ChannelType)channelType AndCmdId:(uint32_t)cmdId NS_UNAVAILABLE;
@end
