//
//  MessageNotify.cpp
//  VoiceTutorial
//
//  Created by apollo on 8/23/16.
//
//
#include "CloudVoice.hpp"
#include "MessageNotify.hpp"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    MessageNotify::MessageNotify(CloudVoice *section)
    :_section(section)
    {

    }
#endif
void MessageNotify::OnUploadFile(gcloud_voice::GCloudVoiceCompleteCode code, const char *filePath, const char *fileID)
{
    if (code == gcloud_voice::GV_ON_UPLOAD_RECORD_DONE) {
//        _section->setText("OnUploadFile success");
        _section->setFileID((char *)fileID);
        UserDefault::getInstance()->setStringForKey("OnUploadFile", "1");
    } else {
//        _section->setText("OnUploadFile error");
    }
}


void MessageNotify::OnDownloadFile(gcloud_voice::GCloudVoiceCompleteCode code, const char *filePath, const char *fileID)
{
    if (code == gcloud_voice::GV_ON_DOWNLOAD_RECORD_DONE) {
//        _section->setText("OnDownloadFile success");
        UserDefault::getInstance()->setStringForKey("OnDownloadFile", "-1");
        _section->PlayRecordedFile();
    } else {
//        _section->setText("OnDownloadFile error");
    }
}

void MessageNotify::OnPlayRecordedFile(gcloud_voice::GCloudVoiceCompleteCode code,const char *filePath)
{
    UserDefault::getInstance()->setStringForKey("OnPlayRecordedFile", "1");
    log("播放完成监听");
}

void MessageNotify::OnApplyMessageKey(gcloud_voice::GCloudVoiceCompleteCode code)
{
    std::string msg;
    if (code == gcloud_voice::GV_ON_MESSAGE_KEY_APPLIED_SUCC) {
        msg = "OnApplyMessageKey success";
    } else {
        msg = &"OnApplyMessageKey error " [ code];
    }
    CCLOG("%s", msg.c_str());
//    _section->setText(msg);
}
