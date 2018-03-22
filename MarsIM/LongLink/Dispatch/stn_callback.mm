// Tencent is pleased to support the open source community by making Mars available.
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.

// Licensed under the MIT License (the "License"); you may not use this file except in 
// compliance with the License. You may obtain a copy of the License at
// http://opensource.org/licenses/MIT

// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

/** * created on : 2012-11-28 * author : yerungui, caoshaokun
 */
#include "stn_callback.h"

#import <mars/comm/autobuffer.h>
#import <mars/xlog/xlogger.h>
#import <mars/stn/stn.h>

#import "LongLinkTool.h"

namespace mars {
    namespace stn {
        
StnCallBack* StnCallBack::instance_ = NULL;
        
StnCallBack* StnCallBack::Instance() {
    if(instance_ == NULL) {
        instance_ = new StnCallBack();
    }
    
    return instance_;
}
        
void StnCallBack::Release() {
    delete instance_;
    instance_ = NULL;
}
// 是否auth认证完成过,需要设置CGITask的need_auth设置为true
bool StnCallBack::MakesureAuthed() {
   return [[LongLinkTool sharedLongLink] isAuthed];
}

// 流量统计
void StnCallBack::TrafficData(ssize_t _send, ssize_t _recv) {
    xdebug2(TSF"send:%_, recv:%_", _send, _recv);
}
        // 底层询问上层该host对应的ip列表
std::vector<std::string> StnCallBack::OnNewDns(const std::string& _host) {
    std::vector<std::string> vector;

    return vector;
}
        
// 接受消息（网络层收到push消息回调）
void StnCallBack::OnPush(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
    if (_body.Length() > 0) {
        NSData* recvData = [NSData dataWithBytes:(const void *) _body.Ptr() length:_body.Length()];
        [[LongLinkTool sharedLongLink] OnPushWithCmd:_cmdid data:recvData];
    }
    
}
// 底层获取task要发送的数据
bool StnCallBack::Req2Buf(uint32_t _taskid, void* const _user_context, AutoBuffer& _outbuffer, AutoBuffer& _extend, int& _error_code, const int _channel_select) {
    /* 发送时的requestData */
    NSData * requestData = [[LongLinkTool sharedLongLink] Request2BufferWithTaskID:_taskid userContext:_user_context];
    if (requestData == nil) {
        requestData = [[NSData alloc] init];
    }
    _outbuffer.AllocWrite(requestData.length);
    _outbuffer.Write(requestData.bytes,requestData.length);
    return requestData.length > 0;
}
// 底层回包返回给上层解析
int StnCallBack::Buf2Resp(uint32_t _taskid, void* const _user_context, const AutoBuffer& _inbuffer, const AutoBuffer& _extend, int& _error_code, const int _channel_select) {
    
    int handle_type = mars::stn::kTaskFailHandleNormal;
    NSData* responseData = [NSData dataWithBytes:(const void *) _inbuffer.Ptr() length:_inbuffer.Length()];
    /* 返回的reponseData数据 */
    NSInteger errorCode = [[LongLinkTool sharedLongLink]Buffer2ResponseWithTaskID:_taskid ResponseData:responseData userContext:_user_context];
    
    if (errorCode != 0) {
        handle_type = mars::stn::kTaskFailHandleDefault;
    }
    
    return handle_type;
}
// 任务执行结束
int StnCallBack::OnTaskEnd(uint32_t _taskid, void* const _user_context, int _error_type, int _error_code) {
    /* 接受结束的数据 */
    return [[LongLinkTool sharedLongLink] OnTaskEndWithTaskID:_taskid userContext:_user_context errType:_error_type errCode:_error_code];
}
        
// 上报网络连接状态
void StnCallBack::ReportConnectStatus(int _status, int longlink_status) {
    [[LongLinkTool sharedLongLink] OnConnectionStatusChange:_status longConnStatus:longlink_status];
    switch (longlink_status) {
        case mars::stn::kServerFailed:
        case mars::stn::kServerDown:
        case mars::stn::kGateWayFailed:
            break;
        case mars::stn::kConnecting:
            break;
        case mars::stn::kConnected:
            break;
        case mars::stn::kNetworkUnkown:
            return;
        default:
            return;
    }
    
}

        
        // 长连信令校验 ECHECK_NOW = 0, ECHECK_NEXT = 1, ECHECK_NEVER = 2
// synccheck：长链成功后由网络组件触发
// 需要组件组包，发送一个req过去，网络成功会有resp，但没有taskend，处理事务时要注意网络时序
// 不需组件组包，使用长链做一个sync，不用重试
int  StnCallBack::GetLonglinkIdentifyCheckBuffer(AutoBuffer& _identify_buffer, AutoBuffer& _buffer_hash, int32_t& _cmdid) {
    _cmdid = 1001;
    NSData * requestData = [[LongLinkTool sharedLongLink] authRequestData];
    if (requestData) {
        _identify_buffer.AllocWrite(requestData.length);
        _identify_buffer.Write(requestData.bytes,requestData.length);
        
        return IdentifyMode::kCheckNow;
    }
    return IdentifyMode::kCheckNever;
}
// 长连接信令校验回包
bool StnCallBack::OnLonglinkIdentifyResponse(const AutoBuffer& _response_buffer, const AutoBuffer& _identify_buffer_hash) {
    NSData* responseData = [NSData dataWithBytes:(const void *) _response_buffer.Ptr() length:_response_buffer.Length()];
    return [[LongLinkTool sharedLongLink] authResponseData:responseData];
    
}
//
void StnCallBack::RequestSync() {

}
        
        
    }
}






