//
//  LongLinkTool.h
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C2CsendTask.h"
#import "AuthTask.h"


@protocol LongLinkAuthDelegate <NSObject>
@optional
- (BOOL)longLinkAuthed;
- (BOOL)longLinkAuthRequestWithUid:(NSString **)uid token:(NSString **)token domain:(int32_t *)domain;
- (BOOL)longlinkAuthResponseWithStatus:(int32_t)status errCode:(int32_t)code errMsg:(NSString *)msg;
@end


@protocol LongLinkPushDelegate <NSObject>
@optional
- (void)longlinkPushMessage:(NSData*)pushData withCmdId:(int)cmdId;
@end




@interface LongLinkTool : NSObject
+ (instancetype)sharedLongLink;

// 创建连接
- (void)createLongLinkWithAddress:(NSString *)addr ports:(NSArray *)ports clientVersion:(uint32_t)version;
-(void)reportOnForegroud:(BOOL)foreground;
- (void)destoryLongLink;

/* 添加其他protobufer */
- (void)addLongLinkPushObserver:(id<LongLinkPushDelegate>)observer withCmdId:(NSInteger)cmdId;


/* 接受消息和cmdid */
- (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data;

/* 向服务器确认消息 */
- (void)OnConnectionStatusChange:(int)status longConnStatus:(int32_t)longConnStatus;
/* 发送的request数据 */
- (NSData *)Request2BufferWithTaskID:(uint32_t)tid userContext:(const void *)context;

/* 接受的数据responseData */
- (int)Buffer2ResponseWithTaskID:(uint32_t)tid ResponseData:(NSData *)data userContext:(const void *)context;
/* 接受结束相应 */
- (int)OnTaskEndWithTaskID:(uint32_t)tid userContext:(const void *)context errType:(int)errtype errCode:(int)errcode;
/* 接受到消息给服务端相应 */
- (uint32_t)pushResponseWithCmdId:(int)cmdid messageId:(int64_t)msgid extra:(NSString *)extra;



/* auth认证 */
@property (nonatomic, weak) id<LongLinkAuthDelegate> authDelegate;
- (NSData*)authRequestData;
/* 认证期间接受数据 */
- (BOOL)authResponseData:(NSData*)responseData;
/* 主动确认auth认证或者从后台到前台在次主动认证auth */
- (uint32_t)startAuthWithUserId:(NSString *)uid token:(NSString *)token domain:(int32_t)domain onResult:(void (^)(BOOL, AuthResponse *))result;


/* 个人对个人 */
- (uint32_t)startC2CSendWithFrom:(NSString *)from fromName:(NSString *)fromName to:(NSString *)to toDomain:(int32_t)toDomain content:(NSString *)content type:(int32_t)type onResult:(void (^)(BOOL, C2CSendResponse *))result;

@end
