//
//  UM_Share.cpp
//  pinlegame
//
//  Created by Kennedy on 16/5/19.
//
//

#include "UM_Share.hpp"
#include "Cocos2dx/Common/CCUMSocialSDK.h"

USING_NS_UM_SOCIAL;

USING_NS_CC;

#include "ui/CocosGUI.h"
using namespace cocos2d::experimental::ui;

static string _sharePicPath;

UM_Share::UM_Share()
{
 
}
UM_Share::~UM_Share()
{
}

UM_Share* UM_Share::create()
{
    UM_Share* widget = new (std::nothrow) UM_Share();
    if (widget && widget->init())
    {
        widget->autorelease();
        UserDefault::getInstance()->setStringForKey("share_call", "-1");
        //widget->setDirection(Direction::HORIZONTAL); ////默认水平方向
        return widget;
    }
    else
    {
        CC_SAFE_DELETE(widget);
    }

    return nullptr;
}
UM_Share* UM_Share::createWithShare(string sharePicPath,string  title,string content,string openid)
{

    UM_Share* layer=new UM_Share();
    if(layer)
    {
        UserDefault::getInstance()->setStringForKey("share_call", "-1");
        layer->initWithShare(sharePicPath,title,content,openid);
        
        layer->autorelease();
        return layer;
    }
    return NULL;
}

bool UM_Share::initWithShare(string sharePicPath,string  title,string content,string openid)
{
    if ( !Layer::init() )
    {
        return false;
    }
    CCLOG("content contentcontentcontent 得到的 = %s",content.c_str());
    if (content!="") {
        shareWithAll(sharePicPath,title,content,openid);

    }else
    {
        boardcustomShare(sharePicPath);
    }
    
   
//    getlogin();
    return true;
}


void shareCallback(int platform, int stCode, string& errorMsg)
{
    if ( stCode == 100 )
    {
        CCLog("#### HelloWorld 开始分享");
    }
    else if ( stCode == 200 )
    {
        UserDefault::getInstance()->setStringForKey("share_call", "0");
        CCLog("#### HelloWorld 分享成功");
    }
    else
    {
        UserDefault::getInstance()->setStringForKey("share_call", "1");
        CCLog("#### HelloWorld 分享出错");
    }

    CCLog("platform num is : %d.", platform);
}


void boardDismissCallback() {
    UserDefault::getInstance()->setStringForKey("share_call", "2");
    log("dismiss");

}

void boardCallback(int platform) {
        
//    CCLog("platform num is : %d", platform);
    log("分享---%s",_sharePicPath.c_str());
    CCUMSocialSDK *sdk = CCUMSocialSDK::create();
    sdk->directShare(platform,
                         "Umeng Social Cocos2d-x SDK -->  qqshare   DIFFERENT CONTENT","title" ,"",_sharePicPath.c_str(),
                         share_selector(shareCallback));
}



void UM_Share::shareWithAll(string sharePicPath,string title,string content,string openid)
{
    log("dismiss");
//    CCLog("UM_Share");
    umeng::social::CCUMSocialSDK *sdk = umeng::social::CCUMSocialSDK::create( );
    vector<int>* platforms = new vector<int>();
    platforms->push_back(umeng::social::WEIXIN);
    platforms->push_back(umeng::social::WEIXIN_CIRCLE);
    //sdk->setPlatforms(platforms);
    //掌间牛牛
//    string url="http://www.sharkpoker.cn/download/game_id/21/homenum/";
    //和和牛牛
    string url="http://www.sharkpoker.cn/download/game_id/24/homenum/";
    url+=openid.c_str();
    
    sdk->setBoardDismissCallback(boarddismiss_selector(boardDismissCallback));
    sdk->openShare(platforms, content.c_str(), title.c_str() ,sharePicPath.c_str(),url.c_str(),share_selector(shareCallback));

}


void UM_Share::boardcustomShare(string sharePicPath) {
    CCUMSocialSDK *sdk = CCUMSocialSDK::create( );
    vector<int>* platforms = new vector<int>();
    platforms->push_back(WEIXIN);
    platforms->push_back(WEIXIN_CIRCLE);
    _sharePicPath=sharePicPath;
    
    sdk->setBoardDismissCallback(boarddismiss_selector(boardDismissCallback));
    sdk->openCustomShare(platforms, board_selector(boardCallback));
    
}



//void UM_Share::add_WebView(string url, cocos2d::Size size, Point point)
//{
//
//
//    WebView *webView = WebView::create();
//
//    webView->setPosition(Vec2(point.x, point.y));
//
//    webView->setContentSize(size);
//
//    webView->loadURL(url);
//
//    webView->setScalesPageToFit(true);
//
//    webView->setOnDidFinishLoading([](WebView *sender, const std::string &url){
//        log("加载成功");
//
//    });
//
//    webView->setOnDidFailLoading([](WebView *sender, const std::string &url){
//
//        log("加载完成");
//
//    });
//
//    this->addChild(webView);
//}


void getCallback(int platform, int stCode, map<string, string>& data) {
    log("*************");
    
    string result = "";
    if (stCode == 200) {
        result = "获取成功";
        log("#### 获取成功");
    } else if (stCode == 0) {
        log("#### 获取出错");
        UserDefault::getInstance()->setStringForKey("share_call", "2");
    } else if (stCode == -1) {
        log("#### 取消获取");
        UserDefault::getInstance()->setStringForKey("share_call", "2");
    }
    log("####222 %s",result.c_str());
    // 输入授权数据, 如果授权失败,则会输出错误信息
      
    map<string, string>::iterator it = data.begin();
    for (; it != data.end(); ++it) {
        log("#### data  %s -> %s.", it->first.c_str(), it->second.c_str());
        UserDefault::getInstance()->setStringForKey(it->first.c_str(), it->second.c_str());
    }
    
}

void getCallback1(int platform, int stCode, map<string, string>& data) {
    log("*************");
    string result = "";
    if (stCode == 200) {
        result = "获取成功";
        log("#### 获取成功");
    } else if (stCode == 0) {
        log("#### 获取出错");
        UserDefault::getInstance()->setStringForKey("share_call", "2");
    } else if (stCode == -1) {
        log("#### 取消获取");
        UserDefault::getInstance()->setStringForKey("share_call", "2");
    }
    log("####222 %s",result.c_str());
    // 输入授权数据, 如果授权失败,则会输出错误信息
    
    map<string, string>::iterator it = data.begin();
    for (; it != data.end(); ++it) {
        log("#### data  %s -> %s.", it->first.c_str(), it->second.c_str());
        UserDefault::getInstance()->setStringForKey(it->first.c_str(), it->second.c_str());
    }
}

void UM_Share::getlogin()
{
    
    CCUMSocialSDK *sdk = CCUMSocialSDK::create();
    sdk->setLogEnable(true);
    sdk->setBoardDismissCallback(boarddismiss_selector(boardDismissCallback));
    sdk->getPlatformInfo(WEIXIN, auth_selector(getCallback));
    bool authon = sdk->isAuthorized(WEIXIN);
    printf("当前的授权信息  = ",authon);
//    sdk->authorize(WEIXIN, auth_selector(getCallback1));
}










