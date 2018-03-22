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

@interface ViewController ()<LongLinkAuthDelegate,LongLinkPushDelegate,LongLinkContectDelegate>
@property (nonatomic) BOOL authed;

@property (nonatomic, strong) UITextField * sendText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LongLinkTool sharedLongLink] setAuthDelegate:self];
    [[LongLinkTool sharedLongLink] setConnectDelegate:self];
    
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
    if (cmdId == 1003) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"被踢下线" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)longlinkContectStatusDidChanged:(LongLinkStatus)status {
    NSLog(@"\n\n\n------\n\n\n");
}
#pragma mark authDelegate
-(BOOL)longLinkAuthed {
    return YES;
}

- (BOOL)longLinkAuthRequestWithUid:(NSString *__autoreleasing *)uid token:(NSString *__autoreleasing *)token domain:(int32_t *)domain {
    _authed = NO;
    *uid = @"222594";
    *token = @"d625bd5cf7610d5cf08a18d48b5b1414";
    *domain = 0;
    return YES;
}

- (BOOL)longlinkAuthResponseWithStatus:(int32_t)status errCode:(int32_t)code errMsg:(NSString *)msg {
    return [self p_parseAuthStatus:status errCode:code andReason:msg];
}

- (BOOL)p_parseAuthStatus:(int32_t)status errCode:(int32_t)code andReason:(NSString *)reason {
    _authed = status == AuthResponse_Status_Ok;
    // 认证成功，进行拉取离线消息
    if (_authed) {
        NSLog(@"success------------------认证成功");
        
    } else {
        NSLog(@"failure------------------认证失败");
    }
    
    return _authed;
}


@end

