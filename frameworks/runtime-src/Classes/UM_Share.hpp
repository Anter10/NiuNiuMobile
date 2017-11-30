//
//  UM_Share.hpp
//  pinlegame
//
//  Created by Kennedy on 16/5/19.
//
//

#ifndef UM_Share_hpp
#define UM_Share_hpp

#include <stdio.h>
#include <stdio.h>
#include "cocos2d.h"
//#include "CCUMTypeDef.h"
#include "Cocos2dx/Common/CCUMSocialSDK.h"
USING_NS_UM_SOCIAL;
using namespace std;

USING_NS_CC;
class UM_Share :public Layer
{
public:
    UM_Share();
    ~UM_Share();
    static UM_Share* create();
//    CREATE_FUNC(UM_Share);
    
    //传入分享图片路径
    static UM_Share* createWithShare(string sharePicPath,string  title,string content,string openid);
    
    bool initWithShare(string sharePicPath,string  title,string content,string openid);

    void shareWithAll(string sharePicPath,string  title,string content,string openid);//友盟SDK分享
    
//    void add_WebView(string url,Size size, Point point);
    
    void boardcustomShare(string sharePicPath);
public:
    void getlogin();//获取授权信息
    
//    static int getInternetConnectionStatus();
};

#endif /* UM_Share_hpp */

 
