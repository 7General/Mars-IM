//
//  C2CsendTask.h
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "CGITask.h"
#import "C2Csend.pbobjc.h"

@interface C2CsendTask : CGITask
+ (instancetype)taskWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void(^)(BOOL success, C2CSendResponse *response))result;
- (instancetype)initWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void(^)(BOOL success, C2CSendResponse *response))result;
@end
