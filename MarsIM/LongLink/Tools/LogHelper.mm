// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

//
//  LogHelper.m
//  iOSDemo
//
//  Created by caoshaokun on 16/11/30.
//  Copyright © 2016年 caoshaokun. All rights reserved.
//

#import "LogHelper.h"
#import <sys/xattr.h>
#import <mars/xlog/xlogger.h>
#import <mars/xlog/appender.h>


static NSUInteger g_processID = 0;
static BOOL __hasOpen = NO;


@implementation LogHelper

+ (void)openXLogWithPath:(NSString *)path logLever:(TLogLevel)level {
    // set do not backup for logpath
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr([path UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    xlogger_SetLevel(kLevelDebug);
    appender_set_console_log(true);
    appender_open(kAppednerAsync, [path UTF8String], "LONGLINK", "");
    
    __hasOpen = YES;
}

+ (void)closeXLog {
    __hasOpen = NO;
    appender_close();
}


static NSString *__model = @"LONGLINK";
+ (void)setModelName:(NSString *)model {
    __model = model;
}

+ (BOOL)hasOpenXLog {
    return __hasOpen;
}

+ (BOOL)shouldLog:(TLogLevel)level {
    if (level >= xlogger_Level()) {
        return YES;
    }
    return NO;
}
+ (void)logWithLevel:(TLogLevel)logLevel fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message {
    XLoggerInfo info;
    info.level = logLevel;
    info.tag = __model.UTF8String;
    info.filename = fileName;
    info.func_name = funcName;
    info.line = lineNumber;
    gettimeofday(&info.timeval, NULL);
    info.tid = (uintptr_t)[NSThread currentThread];
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = g_processID;
    xlogger_Write(&info, message.UTF8String);
}

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message {
    XLoggerInfo info;
    info.level = logLevel;
    info.tag = moduleName;
    info.filename = fileName;
    info.func_name = funcName;
    info.line = lineNumber;
    gettimeofday(&info.timeval, NULL);
    info.tid = (uintptr_t)[NSThread currentThread];
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = g_processID;
    xlogger_Write(&info, message.UTF8String);
}

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName format:(NSString *)format, ... {
    if ([self shouldLog:logLevel]) {
        va_list argList;
        va_start(argList, format);
        NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
        [self logWithLevel:logLevel moduleName:moduleName fileName:fileName lineNumber:lineNumber funcName:funcName message:message];
        va_end(argList);
    }
}



@end
