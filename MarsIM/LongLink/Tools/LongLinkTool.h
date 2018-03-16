//
//  LongLinkTool.h
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GZIMLongLinkAuthDelegate <NSObject>
@optional
- (BOOL)longLinkAuthed;
- (BOOL)longLinkAuthRequestWithUid:(NSString **)uid token:(NSString **)token domain:(int32_t *)domain;
- (BOOL)longlinkAuthResponseWithStatus:(int32_t)status errCode:(int32_t)code errMsg:(NSString *)msg;
@end


@interface LongLinkTool : NSObject
+ (instancetype)sharedLongLink;

// 创建连接
- (void)createLongLinkWithAddress:(NSString *)addr ports:(NSArray *)ports clientVersion:(uint32_t)version;
-(void)reportOnForegroud:(BOOL)foreground;
- (void)destoryLongLink;


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


/* auth认证 */
@property (nonatomic, weak) id<GZIMLongLinkAuthDelegate> authDelegate;
- (NSData*)authRequestData;
/* 认证期间接受数据 */
- (BOOL)authResponseData:(NSData*)responseData;

@end
