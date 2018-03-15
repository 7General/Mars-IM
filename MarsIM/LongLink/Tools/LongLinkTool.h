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

- (void)createLongLinkWithAddress:(NSString *)addr ports:(NSArray *)ports clientVersion:(uint32_t)version;

-(void)reportOnForegroud:(BOOL)foreground;

- (void)destoryLongLink;

@end
