//
//  LongLinkTool.m
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "LongLinkTool.h"

#import <SystemConfiguration/SCNetworkReachability.h>

#import "NetworkDelegate.h"
#import "CGITask.h"

#import "app_callback.h"
#import "stn_callback.h"

#import <mars/app/app_logic.h>
#import <mars/baseevent/base_logic.h>
#import <mars/xlog/xlogger.h>
#import <mars/xlog/xloggerbase.h>
#import <mars/xlog/appender.h>

#import "stnproto_logic.h"

#import "NetworkStatus.h"
#import "NetworkStatus.h"

#import "Auth.pbobjc.h"



using namespace mars::stn;


@interface LongLinkTool()<NetworkStatusDelegate>
/* 发送的task */
@property (nonatomic, strong) NSMutableDictionary * sendTaskDictionary;

@end

@implementation LongLinkTool

+ (instancetype)sharedLongLink {
    static LongLinkTool *sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[LongLinkTool alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sendTaskDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}



// 创建长连接
#pragma mark - Public
- (void)createLongLinkWithAddress:(NSString *)addr ports:(NSArray *)ports clientVersion:(uint32_t)version
{
    mars::stn::SetCallback(mars::stn::StnCallBack::Instance());
    mars::app::SetCallback(mars::app::AppCallBack::Instance());
    
    mars::baseevent::OnCreate();
    mars::stn::SetClientVersion(version);
    
    std::string ipAddress([addr UTF8String]);
    std::vector<uint16_t> cports;
    for (id port in ports) {
        cports.push_back([port unsignedShortValue]);
    }
    mars::stn::SetLonglinkSvrAddr(ipAddress,cports,"");
    mars::baseevent::OnForeground(YES);
    mars::stn::MakesureLonglinkConnected();
    
    [[NetworkStatus sharedInstance] Start:self];
}

-(void)reportOnForegroud:(BOOL)foreground {
    mars::baseevent::OnForeground(foreground);
}
- (void)destoryLongLink {
    mars::baseevent::OnDestroy();
}





/* 接受消息和cmdid */
- (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data {
    
}

/* 确认长连接状态 */
- (void)OnConnectionStatusChange:(int)status longConnStatus:(int32_t)longConnStatus {
//    GZIMLongLinkStatus llStatus;
//    switch (longConnStatus) {
//        case 4:
//            llStatus = GZIMLongLinkStatusConnected;
//            break;
//        case 3:
//            llStatus = GZIMLongLinkStatusConnecting;
//            break;
//        default:
//            llStatus = GZIMLongLinkStatusDisconnected;
//            break;
//    }
//    if (_connectDelegate && [_connectDelegate respondsToSelector:@selector(longlinkContectStatusDidChanged:)]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_connectDelegate longlinkContectStatusDidChanged:llStatus];
//        });
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kGZIMLongLinkStatusObserverName object:nil userInfo:@{kGZIMLongLinkStatus:@(llStatus)}];
//        });
//    }
}


- (NSData *)Request2BufferWithTaskID:(uint32_t)tid userContext:(const void *)context {
    NSData * data = NULL;
    CGITask * task = [self.sendTaskDictionary objectForKey:@(tid)];
    if (task) {
        data = [task requestData];
    }
    if (task.send_only) {
        [self.sendTaskDictionary removeObjectForKey:@(tid)];
    }
    return data;
}


- (int)Buffer2ResponseWithTaskID:(uint32_t)tid ResponseData:(NSData *)data userContext:(const void *)context {
    CGITask *task = [_sendTaskDictionary objectForKey:@(tid)];
    if (task) {
        [task onDecodeData:data];
    }
    return 0;
}

- (int)OnTaskEndWithTaskID:(uint32_t)tid userContext:(const void *)context errType:(int)errtype errCode:(int)errcode {
    CGITask *task = [_sendTaskDictionary objectForKey:@(tid)];
    if (task) {
        [task onTaskEnd:errtype code:errcode];
    }
    [_sendTaskDictionary removeObjectForKey:@(tid)];
    return 0;
}


// auth认证开始
/* 认证期间发送数据 */
- (NSData*)authRequestData
{
    NSData* data = NULL;
    if (_authDelegate && [_authDelegate respondsToSelector:@selector(longLinkAuthRequestWithUid:token:domain:)]) {
        NSString *uid = nil;
        NSString *token = nil;
        int32_t domain;
        BOOL ok = [_authDelegate longLinkAuthRequestWithUid:&uid token:&token domain:&domain];
        if (ok) {
            AuthRequest *request = [AuthRequest new];
            request.uid = uid;
            request.token = token;
            request.domain = domain;
            request.timestamp = (int64_t)([[NSDate date] timeIntervalSince1970]*1000);
            data = [request data];
        }
    }
    return data;
}
/* 认证期间接受数据 */
- (BOOL)authResponseData:(NSData*)responseData
{
    BOOL authed = NO;
    if (_authDelegate && [_authDelegate respondsToSelector:@selector(longlinkAuthResponseWithStatus:errCode:errMsg:)]) {
        AuthResponse *response = [AuthResponse parseFromData:responseData error:nil];
        authed = [_authDelegate longlinkAuthResponseWithStatus:response.status errCode:response.errCode errMsg:response.errMsg];
    }
    return authed;
}




#pragma mark - NetworkStatusDelegate
-(void)ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
}
@end
