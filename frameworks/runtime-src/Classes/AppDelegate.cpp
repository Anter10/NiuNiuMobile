#include "AppDelegate.h"
#include "UM_Share.hpp"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"

#include "protobuf/lfs.h"
//#include  "iospay.h"


//#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "lua_CloudVoice.hpp"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS or CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "GCloudVoice/include/GCloudVoice.h"
#include "lua_UM_Share.hpp"
//#include "LuaMgr.h"
//#include "lua_LuaFunction.hpp"

#endif
//#include "GCloudVoice.h"
// #define USE_AUDIO_ENGINE 1
// #define USE_SIMPLE_AUDIO_ENGINE 1

#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif

extern"C"{
    int luaopen_pb(lua_State* L);
}
USING_NS_CC;
using namespace std;


void AppDelegate::um_module_register(lua_State *L)
{
    #if CC_TARGET_PLATFORM == CC_PLATFORM_IOS or CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        luaopen_pb(L);//绑定pb
        luaopen_lfs(L);//绑定文件
    #endif
}


AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
#if USE_AUDIO_ENGINE
    AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::end();
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, Text Director
// don't modify or remove this function WebSocket XMLHttpRequest
static int register_all_packages()
{
    return 0; //flag for packages manager 
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
//    LuaMgr::registerFish();
    #if CC_TARGET_PLATFORM == CC_PLATFORM_IOS or CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        register_all_UM_Share(L);//绑定友盟
        register_all_CloudVoice(L);//绑定语音
        um_module_register(L);
    #endif
    
//    register_all_LuaFunction(L);
    register_all_packages();
    
    
    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));

    //register custom function
//    LuaStack* stack = engine->getLuaStack();WebView Text Director UserDefault WebSocket
    
   
    
#if CC_64BITS
    FileUtils::getInstance()->addSearchPath("src/64bit");
#endif
    FileUtils::getInstance()->addSearchPath("src");
    FileUtils::getInstance()->addSearchPath("res");
    if (engine->executeScriptFile("main.lua"))
    {
        return false;
    }
    
    

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
         gcloud_voice::GetVoiceEngine()->Pause();
    
#endif
    
#if USE_AUDIO_ENGINE
    AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();
#endif
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        gcloud_voice::GetVoiceEngine()->Resume();
#endif 
    
    //注册自定义监听事件
    auto dispatcher = Director::getInstance()->getEventDispatcher();
    if (dispatcher) {
        dispatcher->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
    }
//#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//    iospay * pDelegate=  [[iospay alloc] initWithIosPay];
//    if (pDelegate) {
//        NSLog(@"pDelegate  != nil");
//        [pDelegate  buy:waresid+1];
//    }
//    else{
//        NSLog(@"pDelegate  != nil");
//    }
//
//#endif
   
    
#if USE_AUDIO_ENGINE
    AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();
#endif
}
