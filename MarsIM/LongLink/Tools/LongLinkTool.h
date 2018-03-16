//
//  LongLinkTool.h
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import <Foundation/Foundation.h>

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




@end
