//
//  main.m
//  MarsIM
//
//  Created by zzg on 2018/3/15.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LogHelper.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/log"];
        
#if DEBUG
        [LogHelper openXLogWithPath:logPath logLever:kLevelDebug];
#else
        [LogHelper openXLogWithPath:logPath logLever:kLevelInfo];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
