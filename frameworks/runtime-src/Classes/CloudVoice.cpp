//
//  GCloudVoice.cpp
//  ZJNN
//
//  Created by admin on 2017/8/22.
//
//

#include "CloudVoice.hpp"
#include "GCloudVoice/include/GCloudVoice.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#define  CLASS_NAME "org/cocos2dx/lua/AppActivity"
#endif


CloudVoice::CloudVoice()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    _dpath =  _wpath =  FileUtils::getInstance()->getWritablePath();
    _wpath += "/audio.dat";
    _dpath += "/downlad.dat";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    _dpath =  _wpath =  FileUtils::getInstance()->getWritablePath();
    _wpath += "audio.dat";
    _dpath += "downlad.dat";
#endif
    this->Refresh_ForKey();
    
    
}
CloudVoice::~CloudVoice()
{
    
}

void CloudVoice::Init_Voice(string open_id)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
 
        gcloud_voice::GetVoiceEngine()->SetAppInfo("1227051357","cdf839a4167c23a5cbfea3d752392242",open_id.c_str());
        gcloud_voice::GetVoiceEngine()->Init();
        _notify = new (std::nothrow) MessageNotify(this);
        if (NULL != _notify) {
            gcloud_voice::GetVoiceEngine()->SetNotify(_notify);
        }
        gcloud_voice::GetVoiceEngine()->SetMode(gcloud_voice::IGCloudVoiceEngine::Messages);
        
        gcloud_voice::GCloudVoiceErrno rst;
        rst = gcloud_voice::GetVoiceEngine()->ApplyMessageKey(60000);
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("ApplyMessageKey Error %d", rst);
        }
    
        scheduleUpdate();
    
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    JniMethodInfo info;
    //getStaticMethodInfo判断java定义的静态函数是否存在，返回bool
    bool ret = JniHelper::getStaticMethodInfo(info,CLASS_NAME,"Init_Voice","(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if(ret)
    {
        jobject j_open= info.env->NewStringUTF(open_id.c_str());
        jobject j_wpath= info.env->NewStringUTF(_wpath.c_str());
        jobject j_dpath= info.env->NewStringUTF(_dpath.c_str());
        
        info.env->CallStaticVoidMethod(info.classID,info.methodID,j_open,j_wpath, j_dpath);
    }

 #endif

    
}



void CloudVoice::Refresh_ForKey()
{
    //所有保存字段标示，-1 初始化状态，1 成功，2 失败，
    UserDefault::getInstance()->setStringForKey("OnUploadFile", "-1");
    UserDefault::getInstance()->setStringForKey("OnDownloadFile", "-1");
    UserDefault::getInstance()->setStringForKey("OnPlayRecordedFile", "-1");
    //保存上传完成后回传的fileId
    UserDefault::getInstance()->setStringForKey("fileId", "-1");

}

void CloudVoice::setFileID(string fileID)
{
    if ("" == fileID) {
        return ;
    }
    _fileID = fileID;
    UserDefault::getInstance()->setStringForKey("fileId", fileID);
}


void CloudVoice::StartRecording()
{
   
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
            gcloud_voice::GCloudVoiceErrno rst;
            rst = gcloud_voice::GetVoiceEngine()->StartRecording(_wpath.c_str());
            if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
                CCLOG("StartRecording Error %d", rst);
            }
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    JniMethodInfo info;
    //getStaticMethodInfo判断java定义的静态函数是否存在，返回bool
    bool ret = JniHelper::getStaticMethodInfo(info,CLASS_NAME,"StartRecording","()V");
    if(ret)
    {
        info.env->CallStaticVoidMethod(info.classID,info.methodID);
    }

#endif
}

void CloudVoice::StopRecording()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        gcloud_voice::GCloudVoiceErrno rst;
        rst = gcloud_voice::GetVoiceEngine()->StopRecording();
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("StopPlayFile Error %d", rst);
            return;
        }
        
        //录音完成，自动上传音频文件
        rst = gcloud_voice::GetVoiceEngine()->UploadRecordedFile(_wpath.c_str());
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("UploadRecordedFile Error %d", rst);
        }
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    JniMethodInfo info;
    //getStaticMethodInfo判断java定义的静态函数是否存在，返回bool
    bool ret = JniHelper::getStaticMethodInfo(info,CLASS_NAME,"StopRecording","()V");
    if(ret)
    {
        info.env->CallStaticVoidMethod(info.classID,info.methodID);
    }
    
#endif

}


void CloudVoice::DownloadRecordedFile(string fileId)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

        
        gcloud_voice::GCloudVoiceErrno rst;
        rst = gcloud_voice::GetVoiceEngine()->DownloadRecordedFile(fileId.c_str(), _dpath.c_str());
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("DownloadRecordedFile Error %d", rst);
            return;
        }
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    JniMethodInfo info;
    //getStaticMethodInfo判断java定义的静态函数是否存在，返回bool
    bool ret = JniHelper::getStaticMethodInfo(info,CLASS_NAME,"DownloadRecordedFile","(Ljava/lang/String;)V");
    if(ret)
    {
        jobject j_dpath= info.env->NewStringUTF(fileId.c_str());
        
        info.env->CallStaticVoidMethod(info.classID,info.methodID,j_dpath);
    }
#endif
    //下载完成后自动播放，在下载成功完成后回调调用播放
}

void CloudVoice::PlayRecordedFile()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        
        gcloud_voice::GCloudVoiceErrno rst;
        rst = gcloud_voice::GetVoiceEngine()->PlayRecordedFile(_dpath.c_str());
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("PlayRecordedFile Error %d", rst);
            UserDefault::getInstance()->setStringForKey("OnPlayRecordedFile", "1");
        }
#endif
}


void CloudVoice::StopPlayFile()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

        gcloud_voice::GCloudVoiceErrno rst;
        rst = gcloud_voice::GetVoiceEngine()->StopPlayFile();
        if (rst != gcloud_voice::GCLOUD_VOICE_SUCC) {
            CCLOG("StopPlayFile Error %d", rst);
        }
#endif

}






bool CloudVoice::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
        
    return true;
}





void CloudVoice::update(float delta)
{
    if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    {
        gcloud_voice::GetVoiceEngine()->Poll();
    }
}

void CloudVoice::onEnter()
{
    Layer::onEnter();
   
//    gcloud_voice::GetVoiceEngine()->SetNotify(self);
}





