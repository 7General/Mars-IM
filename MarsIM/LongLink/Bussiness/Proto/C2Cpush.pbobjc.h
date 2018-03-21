// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: c2cpush.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

NS_ASSUME_NONNULL_BEGIN

#pragma mark - C2CpushRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface C2CpushRoot : GPBRootObject
@end

#pragma mark - C2CPushRequest

typedef GPB_ENUM(C2CPushRequest_FieldNumber) {
  C2CPushRequest_FieldNumber_From = 1,
  C2CPushRequest_FieldNumber_Content = 2,
  C2CPushRequest_FieldNumber_Msgid = 3,
  C2CPushRequest_FieldNumber_Timestamp = 4,
  C2CPushRequest_FieldNumber_Type = 5,
  C2CPushRequest_FieldNumber_To = 6,
  C2CPushRequest_FieldNumber_FromName = 7,
};

@interface C2CPushRequest : GPBMessage

/** 发送者 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *from;

/** 消息内容 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *content;

/** 消息服务器对消息的编号 */
@property(nonatomic, readwrite) int64_t msgid;

/** 收到单聊消息的时间戳 */
@property(nonatomic, readwrite) int64_t timestamp;

/** 消息类型，比如文本，图片，文件等 */
@property(nonatomic, readwrite) int32_t type;

/** 接受者 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *to;

@property(nonatomic, readwrite, copy, null_resettable) NSString *fromName;

@end

#pragma mark - C2CPushResponse

typedef GPB_ENUM(C2CPushResponse_FieldNumber) {
  C2CPushResponse_FieldNumber_Msgid = 1,
};

@interface C2CPushResponse : GPBMessage

/** 消息服务器对消息的编号 */
@property(nonatomic, readwrite) int64_t msgid;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)