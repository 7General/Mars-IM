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
#import "C2Cpush.pbobjc.h"

@interface ViewController ()<LongLinkAuthDelegate,LongLinkPushDelegate>
@property (nonatomic) BOOL authed;

@property (nonatomic, strong) UITextField * sendText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LongLinkTool sharedLongLink] setAuthDelegate:self];
    
    [[LongLinkTool sharedLongLink] addLongLinkPushObserver:self withCmdId:(1007)];
    
    self.sendText = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    self.sendText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_sendText];
    
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(100, 200, 100, 100);
    sendButton.backgroundColor = [UIColor redColor];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
}

-(void)sendClick {
    NSLog(@"---发送");
    [[LongLinkTool sharedLongLink] startC2CSendWithFrom:@"222594" fromName:@"王会洲" to:@"226851" toDomain:0 content:(_sendText.text) type:0 onResult:^(BOOL success, C2CSendResponse *response) {
        NSLog(@"---------------------->>>>返回信息");
    }];
}


#pragma mark - 接受push消息
-(void)longlinkPushMessage:(NSData *)pushData withCmdId:(int)cmdId {
    C2CPushRequest *request = [C2CPushRequest parseFromData:pushData error:nil];
    NSLog(@"----接受内容为:%@",request.content);
}


#pragma mark authDelegate
- (BOOL)longLinkAuthRequestWithUid:(NSString *__autoreleasing *)uid token:(NSString *__autoreleasing *)token domain:(int32_t *)domain
{
    _authed = NO;
    *uid = @"222594";
    *token = @"3acefd5c4fbc5644fcd1fab4865fc230";
    *domain = 0;
    return YES;
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

