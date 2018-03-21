//
//  C2CsendTask.m
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "C2CsendTask.h"

@interface C2CsendTask()
@property (nonatomic, strong) C2CSendRequest *request;
@property (nonatomic, strong) C2CSendResponse *response;
@property (nonatomic, copy) void (^onResult)(BOOL, C2CSendResponse *);
@end

@implementation C2CsendTask

+ (instancetype)taskWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void (^)(BOOL, C2CSendResponse *))result
{
    return [[[self class] alloc] initWithFrom:from fromName:fromName to:to toDomain:toDomain content:content type:type onResult:result];
}

- (instancetype)initWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void (^)(BOOL, C2CSendResponse *))result
{
    if (self = [super initAll:ChannelType_LongConn AndCmdId:1006]) {
        self.onResult = result;
        
        C2CSendRequest *request = [C2CSendRequest new];
        request.from = from;
        request.fromName = fromName;
        request.to = to;
        request.toDomain = toDomain;
        request.content = content;
        request.type = type;
        
        self.request = request;
        self.requestData = [request data];
    }
    return self;
}

- (void)onDecodeData:(NSData *)responseData
{
    self.response = [C2CSendResponse parseFromData:responseData error:nil];
    XLOG_INFO(@"C2CSendTask onDecodeData: request = %@, response = %@", self.request.description, self.response.description);
}

- (void)onTaskEnd:(int)errType code:(int)errCode
{
    XLOG_INFO(@"C2CSendTask onTaskEnd: request = %@, errType = %d, errCode = %d", self.request.description, errType, errCode);
    if (self.onResult) {
        self.onResult(errType==0, self.response);
    }
    self.onResult = nil;
}
@end
