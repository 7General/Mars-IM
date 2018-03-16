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



using namespace mars::stn;


@interface LongLinkTool()<NetworkStatusDelegate>
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

/* 向服务器确认收到消息 */
- (void)OnConnectionStatusChange:(int)status longConnStatus:(int32_t)longConnStatus {
    
}





#pragma mark - NetworkStatusDelegate
-(void)ReachabilityChange:(UInt32)uiFlags {
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
}
@end
