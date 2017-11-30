//
//  GCloudVoice.hpp
//  ZJNN
//
//  Created by admin on 2017/8/22.
//
//

#ifndef CloudVoice_hpp
#define CloudVoice_hpp

#include <stdio.h>
#include "cocos2d.h"
#include "GCloudVoice/include/GCloudVoice.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#include "MessageNotify.hpp"
#endif

using namespace std;

USING_NS_CC;
class CloudVoice :public Layer
{
public:
    virtual bool init();
    CREATE_FUNC(CloudVoice);
    CloudVoice();
    ~CloudVoice();
    //    CREATE_FUNC(UM_Share);
    
    void update(float delta);
    virtual void onEnter();
    
    void Init_Voice(string open_id);
    
    void setFileID(string fileID);

    void StartRecording();//开始录音
    void StopRecording();//停止录音//自动上传
    
    void DownloadRecordedFile(string fileId);//下载音频完成后自动播放
    
    void StopPlayFile();//备用停止播放
    
    void PlayRecordedFile();//播放录音
    
    void Refresh_ForKey();
    
private:
    
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    MessageNotify *_notify;
#endif
    std::string _wpath;
    std::string _dpath;
    std::string _fileID;
};

#endif /* GCloudVoice_hpp */
