//
//  LuaMgr.cpp
//  qiqigame
//
//  Created by xtgg on 15/9/10.
//
//

#include "LuaMgr.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

//#include "LuaBinding/lua_MD5_auto.hpp"
//#include "LuaBinding/lua_EventUser_auto.hpp"
//#include "lfs.h"
//#include "cjson/lua_extensions.h"
#include "scripting/lua-bindings/manual/network/lua_extensions.h"
//#include "GcloudVoiceMgr.hpp"
#include <string>
//#include "ManagerJsonData.h"
#include <stdio.h>
#include "json/rapidjson.h"
#include "json/document.h"
#include "json/writer.h"
#include "json/stringbuffer.h"
#include "cocos2d.h"

#include "AppDelegate.h"
using namespace rapidjson;
using namespace cocos2d;
using namespace std;

LuaMgr * LuaMgr::instance = NULL;

LuaMgr * LuaMgr::getInstance(){
    if (instance == NULL){
        instance = new LuaMgr();
    }
    return instance;
}

void LuaMgr::exeFunction(int handler,std::string data)
{
    cocos2d::LuaEngine* pEngine = cocos2d::LuaEngine::getInstance();
    cocos2d::LuaStack* Lstack = pEngine->getLuaStack();
    Lstack->pushString(data.c_str());
    int ret = Lstack->executeFunctionByHandler(handler, 1);
    Lstack->clean();
}

int LuaMgr::exe1FunctionHandler(int handler,const char* sArgFomat, ...){
    cocos2d::LuaEngine* pEngine = cocos2d::LuaEngine::getInstance();
    cocos2d::LuaStack* Lstack = pEngine->getLuaStack();
    lua_State* pState = Lstack->getLuaState();
    va_list vl;
    va_start(vl, sArgFomat);
    size_t nArgNumber = strlen(sArgFomat);
    for (int i = 0;i<nArgNumber;++i)
    {
        switch (sArgFomat[i])
        {
            case 'i':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushInt(va_arg(vl,int));
                break;
            case 's':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushString(va_arg(vl,char*));
                break;
                
            case 'f':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushFloat(va_arg(vl,double));
                break;
            case 'd':
            {
                void* pData = va_arg(vl,void*);
                lua_pushlightuserdata(pState,pData);
            }
                break;
            default:
                break;
        }
    }
    va_end(vl);
    int ret = Lstack->executeFunctionByHandler(handler, (int)nArgNumber);
    //Lstack->clean();
    return ret;
}



void LuaMgr::requestToken(std::string code){
   
    // 请求登陆
    std::string path = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=";
    path.append("wx7c8e10df2692c64d");
    path.append("&secret=");
    path.append("83b3c472ee43101343d4eeb0f99611e6");
    path.append("&code=");
    
    std::stringstream ss;
    ss<<code;
    std::string s1 = ss.str();

    path.append(s1);
    path.append("&grant_type=authorization_code");
    
    
    HttpRequest* request = new (std::nothrow) HttpRequest();
    request->setUrl(path);
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(CC_CALLBACK_2(LuaMgr::onHttpRequestCompleted, this));
    HttpClient::getInstance()->send(request);
    
}


int LuaMgr::exeFunctionHandler(int handler,const char* sArgFomat, ...)
{
//    int thandler = Voice::Delegete::onUploadFileHandler;
 
    cocos2d::LuaEngine* pEngine = cocos2d::LuaEngine::getInstance();
    cocos2d::LuaStack* Lstack = pEngine->getLuaStack();
    lua_State* pState = Lstack->getLuaState();
    va_list vl;
    va_start(vl, sArgFomat);
    size_t nArgNumber = strlen(sArgFomat);
    for (int i = 0;i<nArgNumber;++i)
    {
        switch (sArgFomat[i])
        {
            case 'i':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushInt(va_arg(vl,int));
                break;
            case 's':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushString(va_arg(vl,char*));
                break;
                
            case 'f':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushFloat(va_arg(vl,double));
                break;
            case 'd':
            {
                void* pData = va_arg(vl,void*);
                lua_pushlightuserdata(pState,pData);
            }
                break;
            default:
                break;
        }
    }
    va_end(vl);
    int ret = Lstack->executeFunctionByHandler(handler, (int)nArgNumber);
    //Lstack->clean();
    return ret;
}

int LuaMgr::gameExit(lua_State* pArgs)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8) || (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
    return;
#endif
    Director::getInstance()->end();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
    exit(0);
    return 0;
}

void LuaMgr::exeGlobalFunction(const char* sFuncName)
{
    	cocos2d::LuaEngine::getInstance()->executeGlobalFunction(sFuncName);
}
void LuaMgr::exeGlobalFunction(const char* sFuncName,const char* sArgFomat, ...)
{
    cocos2d::LuaStack* pStack = cocos2d::LuaEngine::getInstance()->getLuaStack();
    lua_State* pState = pStack->getLuaState();
    lua_getglobal(pState, sFuncName);
    if (!lua_isfunction(pState, -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", sFuncName);
        lua_pop(pState, 1);
        return;
    }
    va_list vl;
    va_start(vl, sArgFomat);
    size_t nArgNumber = strlen(sArgFomat);
    for (int i = 0;i<nArgNumber;++i)
    {
        switch (sArgFomat[i])
        {
            case 'i':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushInt(va_arg(vl,int));
                break;
            case 's':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushString(va_arg(vl,char*));
                break;
                
            case 'f':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushFloat(va_arg(vl,double));
                break;
                /*
            case 'b':
                cocos2d::LuaEngine::getInstance()->getLuaStack()->pushBoolean(va_arg(vl,bool));
                break;
                 */
            case 'd':
            {
                void* pData = va_arg(vl,void*);
                lua_pushlightuserdata(pState,pData);
            }
                break;
            default:
                break;
        }
    }
    va_end(vl);
    pStack->executeFunction((int)nArgNumber);
}

void LuaMgr::registerFish()
{
    cocos2d::LuaStack* pStack = cocos2d::LuaEngine::getInstance()->getLuaStack();
    lua_State* pState = pStack->getLuaState();
//    lua_register(pState,"gameExit", LuaMgr::gameExit);
//    lua_register(pState,"addFish", Qiqi_Fish::addFish);
//    lua_register(pState,"addBullet", Qiqi_Fish::addBullet);
//    lua_register(pState,"removeBullet", Qiqi_Fish::removeBullet);
//    lua_register(pState,"removeFish", Qiqi_Fish::removeFish);
//    lua_register(pState,"clearList", Qiqi_Fish::clearList);
//    lua_register(pState,"clearFish", Qiqi_Fish::clearFish);
//    lua_register(pState,"addEffect", Qiqi_Fish::addEffect);
//    lua_register(pState,"showEffect", Qiqi_Fish::showEffect);
}
 

void LuaMgr::registerVoice()
{
    cocos2d::LuaStack* pStack = cocos2d::LuaEngine::getInstance()->getLuaStack();
    lua_State* pState = pStack->getLuaState();
//    lua_register(pState,"StartRecording", Voice::StartRecording);
//    lua_register(pState,"StopRecording", Voice::StopRecording);
//    lua_register(pState,"UploadRecordedFile", Voice::UploadRecordedFile);
//    lua_register(pState,"DownloadRecordedFile", Voice::DownloadRecordedFile);
//    lua_register(pState,"PlayRecordedFile", Voice::PlayRecordedFile);
//    lua_register(pState,"StopPlayFile", Voice::StopPlayFile);
//    lua_register(pState,"setVoiceDelegate", Voice::setVoiceDelegate);
}


//void LuaMgr:: registerCrypto()
//{
//    cocos2d::LuaStack* pStack = cocos2d::LuaEngine::getInstance()->getLuaStack();
//    lua_State* pState = pStack->getLuaState();
//    lua_register(pState,"getMd5", Qiqi_Crypto::getMd5);
//    lua_register(pState,"getDefault", Qiqi_Crypto::getDefault);
//    lua_register(pState,"setDefault", Qiqi_Crypto::setDefault);
//    lua_register(pState, "getBitAnd", Qiqi_Crypto::getBitAnd);
//    lua_register(pState, "getBitOr", Qiqi_Crypto::getBitOr);
//
//    lua_register(pState, "gzuncompress", Qiqi_Crypto::gzuncompress);
//    lua_register(pState, "gzcompress", Qiqi_Crypto::gzcompress);
//    lua_register(pState, "httpSend", Qiqi_Crypto::httpSend);
//    lua_register(pState, "encodeBase64", Qiqi_Crypto::encodeBase64);
//    lua_register(pState, "decodeBase64", Qiqi_Crypto::decodeBase64);
//    lua_register(pState, "encryptXXtea", Qiqi_Crypto::encryptXXtea);
//    lua_register(pState, "decryptXXTea", Qiqi_Crypto::decryptXXTea);
//    lua_register(pState, "encodeMsg", Qiqi_Crypto::encodeMsg);
//    lua_register(pState, "decodeMsg", Qiqi_Crypto::decodeMsg);
//    lua_register(pState, "getDataDat", Qiqi_Crypto::getDataDat);
//    lua_register(pState, "getDataUnicode", Qiqi_Crypto::getDataUnicode);
//    lua_register(pState, "getRectIntersets", Qiqi_Crypto::getRectIntersets);
//    lua_register(pState, "setSSLCaFile", Qiqi_Crypto::setSSLCaFile);
//}
//
//void LuaMgr::registerClass()
//{
//    cocos2d::LuaStack* pStack = cocos2d::LuaEngine::getInstance()->getLuaStack();
//    lua_State* pState = pStack->getLuaState();
//
//    lua_register(pState,"getUniqueIdentifier", LUA_CALL_CPP::getUniqueIdentifier);
//    lua_register(pState,"getCurrentTimeLua",LUA_CALL_CPP::getCurrentTimeLua);
//    lua_register(pState,"setOrientation", LUA_CALL_CPP::setOrientation);
//
//    lua_register(pState,"setDownDelegate", LUA_CALL_CPP::setDownDelegate);
//    lua_register(pState,"downResByFile", LUA_CALL_CPP::downResByFile);
//
//    lua_register(pState,"setWeChatDelegate", LUA_CALL_CPP::setWeChatDelegate);
//    lua_register(pState,"goShare", LUA_CALL_CPP::goShare);
//   // lua_register(pState,"vibrate", LUA_CALL_CPP::vibrate);
//    lua_register(pState,"loginWechat", LUA_CALL_CPP::loginWechat);
//    lua_register(pState,"loginQQ", LUA_CALL_CPP::loginQQ);
//
//    lua_register(pState,"gameExit", LUA_CALL_CPP::gameExit);
//    lua_register(pState,"getVersion", LUA_CALL_CPP::getVersion);
//    lua_register(pState,"getAppName", LUA_CALL_CPP::getAppName);
//    lua_register(pState,"getBundleId", LUA_CALL_CPP::getBundleId);
//    lua_register(pState,"getPlatformVersion", LUA_CALL_CPP::getPlatformVersion);
//    lua_register(pState, "pay", LUA_CALL_CPP::pay);
//    lua_register(pState, "payToWinXin", LUA_CALL_CPP::payToWinXin);
//     lua_register(pState, "payToAliPay", LUA_CALL_CPP::payToAliPay);
//    lua_register(pState, "getNetStatus", LUA_CALL_CPP::getNetStatus);
//    lua_register(pState, "initLocal", LUA_CALL_CPP::initLocal);
//    lua_register(pState, "getLat", LUA_CALL_CPP::getLat);
//    lua_register(pState, "getLng", LUA_CALL_CPP::getLng);
//    lua_register(pState, "getAddress", LUA_CALL_CPP::getAddress);
//    lua_register(pState, "getIp", LUA_CALL_CPP::getIp);
//    lua_register(pState, "startAudioRecorder", LUA_CALL_CPP::startAudioRecorder);
//    lua_register(pState, "stopAudioRecorder", LUA_CALL_CPP::stopAudioRecorder);
//    lua_register(pState, "getPicture", LUA_CALL_CPP::getPicture);
//
//    lua_register(pState, "saveSprite", LUA_CALL_CPP::saveSprite);
//    lua_register(pState, "getApkPath", LUA_CALL_CPP::getApkPath);
//    lua_register(pState, "installApk", LUA_CALL_CPP::installApk);
//    lua_register(pState, "pasteBoard", LUA_CALL_CPP::pasteBoard);
//    lua_register(pState, "pasteBoard", LUA_CALL_CPP::callPhone);
//    lua_register(pState, "getNetInfo", LUA_CALL_CPP::getNetInfo);
//    lua_register(pState, "getBattery", LUA_CALL_CPP::getBattery);
//    lua_register(pState, "getJWD", LUA_CALL_CPP::getJWD);
//    lua_register(pState, "getReFreshToken", LUA_CALL_CPP::getFreshToken);
//    register_all_MD5_api(pState);
//    register_all_EventUser_api(pState);
//   // luaopen_lfs(pState);
//    luaopen_lua_extensions(pState);
//}

