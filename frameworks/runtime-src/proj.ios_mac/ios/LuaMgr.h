//
//  LuaMgr.h
//  qiqigame
//
//  Created by xtgg on 15/9/10.
//
//
#include "cocos2d.h"

#include "cocos2d.h"


#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"

USING_NS_CC;
using namespace cocos2d::network;

struct lua_State;
class LuaMgr
{
public:
    static LuaMgr * instance;
    static LuaMgr * getInstance();
    static void exeFunction(int handler,std::string data);
    static int exeFunctionHandler(int handler,const char* sArgFomat, ...);
    int exe1FunctionHandler(int handler,const char* sArgFomat, ...);
    static void exeGlobalFunction(const char* sFuncName);
    static void exeGlobalFunction(const char* sFuncName,const char* sArgFomat, ...);
    static void registerClass();
    static void registerCrypto();
    static void registerFish();
    static void registerVoice();
    int gameExit(lua_State* pArgs);
    void getToken();
    int number = 0;
    std::string wx_access_token;
    std::string nickname;
    std::string headimgurl;
    int sex;
    //        std::string token = jsonData["token"].GetString();
    std::string openid;
    void onHttpRequestCompleted(HttpClient *sender, HttpResponse *response);
    void requestToken(std::string);
};

