//
//  ViewController.m
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "ViewController.h"
#import "LongLinkTool.h"
#import "Auth.pbobjc.h"

@interface ViewController ()<GZIMLongLinkAuthDelegate>
@property (nonatomic) BOOL authed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[LongLinkTool sharedLongLink] setAuthDelegate:self];
    
}
#pragma mark authDelegate
- (BOOL)longLinkAuthRequestWithUid:(NSString *__autoreleasing *)uid token:(NSString *__autoreleasing *)token domain:(int32_t *)domain
{
    _authed = NO;
//    if (self.isLogin) {
        *uid = @"222594";
        *token = @"3acefd5c4fbc5644fcd1fab4865fc230";
        *domain = 0;
        return YES;
//    }
//    return NO;
}

- (BOOL)longlinkAuthResponseWithStatus:(int32_t)status errCode:(int32_t)code errMsg:(NSString *)msg
{
    return [self p_parseAuthStatus:status errCode:code andReason:msg];
}

- (BOOL)p_parseAuthStatus:(int32_t)status errCode:(int32_t)code andReason:(NSString *)reason
{
    _authed = status == AuthResponse_Status_Ok;
//    XLOG_INFO(@"AuthResponse status=%@, errCode=%d, errMsg:%@", _authed?@"AuthResponse_Status_Ok":@"AuthResponse_Status_Err", code, reason);
    NSLog(@"------------------认证成功");
    // 认证成功，进行拉取离线消息
    if (_authed) {
       
        
    } else {
        
    }
    
    return _authed;
}


@end
