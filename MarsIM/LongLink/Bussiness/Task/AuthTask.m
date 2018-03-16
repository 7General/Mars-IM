//
//  AuthTask.m
//  MarsIM
//
//  Created by zzg on 2018/3/16.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "AuthTask.h"

@interface AuthTask()
@property (nonatomic, strong) AuthRequest *request;
@property (nonatomic, strong) AuthResponse *response;
@property (nonatomic, copy) void (^onResult)(BOOL, AuthResponse *);
@end


@implementation AuthTask
+ (instancetype)taskWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void(^)(BOOL success,AuthResponse * response))result {
    return [[self alloc] initWithUserId:uid token:token domain:domain onResult:result];
}

- (instancetype)initWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void(^)(BOOL success,AuthResponse * response))result {
    if (self = [super initAll:2 AndCmdId:1001]) {
        self.need_auth = false;
        self.onResult = result;
        
        AuthRequest * request = [AuthRequest new];
        request.uid = uid;
        request.token = token;
        request.domain = domain;
        request.timestamp = (int64_t)([[NSDate date] timeIntervalSince1970]*1000);
        
        self.request = request;
        self.requestData = [request data];
    }
    return self;
}

-(void)onDecodeData:(NSData *)responseData {
    self.response = [AuthResponse parseFromData:responseData error:nil];
    
}
- (void)onTaskEnd:(int)errType code:(int)errCode {
    if (self.onResult) {
        self.onResult(errCode == 0, self.response);
    }
    self.onResult = nil;
}


@end
