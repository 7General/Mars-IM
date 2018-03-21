//
//  LongLinkTool.m
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "LongLinkTool.h"

#import <SystemConfiguration/SCNetworkReachability.h>


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

#import "C2CpushTask.h"



using namespace mars::stn;


@interface LongLinkTool()<NetworkStatusDelegate>
/* 发送的task */
@property (nonatomic, strong) NSMutableDictionary * sendTaskDictionary;

@property (nonatomic, strong) NSMapTable * pushObservers;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sendTaskDictionary = [NSMutableDictionary dictionary];
        self.pushObservers = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

-(void)dealloc {
    self.pushObservers = nil;
    self.sendTaskDictionary = nil;
}

// 创建长连接
#pragma mark - Public
- (void)createLongLinkWithAddress:(NSString *)addr ports:(NSArray *)ports clientVersion:(uint32_t)version {
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
/* 添加长连接 */
- (void)addLongLinkPushObserver:(id<LongLinkPushDelegate>)observer withCmdId:(NSInteger)cmdId {
    [self.pushObservers setObject:observer forKey:@(cmdId)];
}
/* 接受服务端推送的消息和cmdid */
- (void)OnPushWithCmd:(NSInteger)cmdId data:(NSData *)data {
    id<LongLinkPushDelegate> pushObserver = [self.pushObservers objectForKey:@(cmdId)];
    if (pushObserver && [pushObserver respondsToSelector:@selector(longlinkPushMessage:withCmdId:)]) {
        [pushObserver longlinkPushMessage:data withCmdId:cmdId];
    }
}


/* 接受到消息给服务端相应 */
- (uint32_t)pushResponseWithCmdId:(int)cmdid messageId:(int64_t)msgid extra:(NSString *)extra {
    uint32_t result = 0;
    switch (cmdid) {
        case 1007:
            [self startTask:[C2CpushTask taskWithMessageId:msgid]];
            break;
            
        default:
            break;
    }
    return result;
}


#pragma mark - 发送消息
- (uint32_t)startC2CSendWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void (^)(BOOL, C2CSendResponse *))result {
    return [self startTask:[C2CsendTask taskWithFrom:from fromName:fromName to:to toDomain:toDomain content:content type:type onResult:result]];
}

- (uint32_t)nextTaskId {
    uint32_t taskid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kGZIMLongLinkUniqueTaskId"] unsignedIntValue];
    uint32_t nextTaskId = 1;
    if (taskid > 0 || taskid < 0xF0000000) {
        nextTaskId = taskid+1;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(nextTaskId) forKey:@"kGZIMLongLinkUniqueTaskId"];
    return nextTaskId;
}
- (uint32_t)startTask:(CGITask*)task {
    uint32_t taskid = [self nextTaskId];
    Task ctask(taskid);
    
    ctask.cmdid = task.cmdid;
    ctask.channel_select = task.channel_select;
    ctask.cgi = std::string(task.cgi.UTF8String);
    ctask.shortlink_host_list.push_back(std::string(task.host.UTF8String));
    
    ctask.send_only = task.send_only;
    ctask.need_authed = task.need_auth;
    ctask.retry_count = task.retry_count;
    
    ctask.user_context = (__bridge void*)task;
    
    [_sendTaskDictionary setObject:task forKey:@(taskid)];
    
    mars::stn::StartTask(ctask);
    return ctask.taskid;
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
- (BOOL)isAuthed {
    BOOL authed = NO;
    if (self.authDelegate && [self.authDelegate respondsToSelector:@selector(longLinkAuthed)]) {
        authed = [self.authDelegate longLinkAuthed];
    }
    return authed;
}


/* 认证期间发送数据 */
- (NSData*)authRequestData {
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
- (BOOL)authResponseData:(NSData*)responseData {
    BOOL authed = NO;
    if (_authDelegate && [_authDelegate respondsToSelector:@selector(longlinkAuthResponseWithStatus:errCode:errMsg:)]) {
        AuthResponse *response = [AuthResponse parseFromData:responseData error:nil];
        authed = [_authDelegate longlinkAuthResponseWithStatus:response.status errCode:response.errCode errMsg:response.errMsg];
    }
    return authed;
}
/* 主动确认auth认证或者从后台到前台在次主动认证auth */
- (uint32_t)startAuthWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void (^)(BOOL, AuthResponse *))result {
    return [self startTask:[AuthTask taskWithUserId:uid token:token domain:domain onResult:result]];
}



#pragma mark - NetworkStatusDelegate
-(void)ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
}
@end
