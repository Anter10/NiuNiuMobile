//
//  MessageNotify.hpp
//  VoiceTutorial
//
//  Created by apollo on 8/23/16.
//
//

#ifndef MessageNotify_hpp
#define MessageNotify_hpp

#include "GCloudVoice/include/GCloudVoice.h"

class CloudVoice;

class MessageNotify : public gcloud_voice::IGCloudVoiceNotify
{
public:
    MessageNotify(CloudVoice *section);
public:
    // Voice Message Callback
    virtual void OnUploadFile(gcloud_voice::GCloudVoiceCompleteCode code, const char *filePath, const char *fileID) ;
    virtual void OnDownloadFile(gcloud_voice::GCloudVoiceCompleteCode code, const char *filePath, const char *fileID) ;
    virtual void OnPlayRecordedFile(gcloud_voice::GCloudVoiceCompleteCode code,const char *filePath) ;
    virtual void OnApplyMessageKey(gcloud_voice::GCloudVoiceCompleteCode code) ;

	virtual void OnJoinRoom(gcloud_voice::GCloudVoiceCompleteCode code, const char *roomName, int memberID) {}
	virtual void OnQuitRoom(gcloud_voice::GCloudVoiceCompleteCode code, const char *roomName) {}
	virtual void OnMemberVoice(const unsigned int *members, int count){}
	virtual void OnSpeechToText(gcloud_voice::GCloudVoiceCompleteCode code, const char *fileID, const char *result) {}
       
private:
    CloudVoice *_section;
};

#endif /* MessageNotify_hpp */
