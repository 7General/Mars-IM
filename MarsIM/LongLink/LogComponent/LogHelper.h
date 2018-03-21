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
//  LogHelper.h
//  iOSDemo
//
//  Created by caoshaokun on 16/11/30.
//  Copyright © 2016年 caoshaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mars/xlog/xloggerbase.h>

@interface LogHelper : NSObject

+ (void)openXLogWithPath:(NSString *)path logLever:(TLogLevel)level;

+ (void)closeXLog;
+ (BOOL)hasOpenXLog;


+ (void)logWithLevel:(TLogLevel)logLevel fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message;

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message;
+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName format:(NSString *)format, ...;

+ (BOOL)shouldLog:(TLogLevel)level;

@end

#define LogInternal(level, file, line, func, prefix, format, ...) \
do { \
    if ([LogHelper shouldLog:level] && [LogHelper hasOpenXLog]) { \
        NSString *aMessage = [NSString stringWithFormat:@"%@%@", prefix, [NSString stringWithFormat:format, ##__VA_ARGS__, nil]]; \
        [LogHelper logWithLevel:level fileName:file lineNumber:line funcName:func message:aMessage]; \
    } \
} while(0)



#define __FILENAME__ (strrchr(__FILE__,'/')+1)

/**
 *  Module Logging
 */
#define LOG_ERROR(format, ...) LogInternal(kLevelError, __FILENAME__, __LINE__, __FUNCTION__, @"Error:", format, ##__VA_ARGS__)
#define LOG_WARNING(format, ...) LogInternal(kLevelWarn, __FILENAME__, __LINE__, __FUNCTION__, @"Warning:", format, ##__VA_ARGS__)
#define XLOG_INFO(format, ...) LogInternal(kLevelInfo, __FILENAME__, __LINE__, __FUNCTION__, @"Info:", format, ##__VA_ARGS__)
#define LOG_DEBUG(format, ...) LogInternal(kLevelDebug, __FILENAME__, __LINE__, __FUNCTION__, @"Debug:", format, ##__VA_ARGS__)







