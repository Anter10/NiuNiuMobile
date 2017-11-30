/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2017 Chukong Technologies Inc.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#import "Reachability.h"
#import "AppController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import<UMSocialCore/UMSocialCore.h>

#include "scripting/lua-bindings/manual/CCLuaEngine.h"
int logincodenumber = 0;

void OCTOCManager::onHttpRequestCompleted(HttpClient *sender, HttpResponse * response)
{
    if (!response)
    {
        return;
    }
    
    // You can get original request type from: response->request->reqType
    if(0 != strlen(response->getHttpRequest()->getTag()))
    {
        log("%s completed", response->getHttpRequest()->getTag());
    }
    std::vector<char> *buffer = response->getResponseData();
    std::string res;
    for (unsigned int i = 0; i < buffer->size(); i++)
    {
        res+=(*buffer)[i];
    }
    printf("请求得到的数据data  = %s",res.c_str());
    
    
    rapidjson::Document jsonData;
    jsonData.Parse<rapidjson::kParseDefaultFlags>(res.c_str());
    
    if(number == 0){
//        std::string access_token = jsonData["access_token"].GetString();
//        std::string openid = jsonData["openid"].GetString();
//
//        wx_access_token =access_token;
//        std::string path = "https://api.weixin.qq.com/sns/userinfo?access_token=";
//        path.append(access_token);
//        path.append("&openid=");
//        path.append(openid);
//        number = 1;
//        HttpRequest* request = new (std::nothrow) HttpRequest();
//        request->setUrl(path);
//        request->setRequestType(HttpRequest::Type::POST);
//        request->setResponseCallback(CC_CALLBACK_2(OCTOCManager::onHttpRequestCompleted, this));
//        HttpClient::getInstance()->send(request);
    }else{
        if (jsonData.HasMember("nickname")){
            nickname   = jsonData["nickname"].GetString();
            headimgurl = jsonData["headimgurl"].GetString();
            sex           = jsonData["sex"].GetInt();
            //        std::string token = jsonData["token"].GetString();
            openid = jsonData["openid"].GetString();
            std::string nickname   = jsonData["nickname"].GetString();
            std::string country    = jsonData["country"].GetString();
            std::string language   = jsonData["language"].GetString();
            std::string headimgurl = jsonData["headimgurl"].GetString();
            std::string unionid    = jsonData["unionid"].GetString();
            std::string city       = jsonData["city"].GetString();

            UserDefault::getInstance()->setStringForKey("name",nickname);
            UserDefault::getInstance()->setStringForKey("country",country);
            UserDefault::getInstance()->setStringForKey("city",city);
            UserDefault::getInstance()->setStringForKey("iconurl",headimgurl);
            UserDefault::getInstance()->setStringForKey("accessToken",wx_access_token);
            UserDefault::getInstance()->setStringForKey("city",city);
            UserDefault::getInstance()->setStringForKey("openid",openid);
            UserDefault::getInstance()->setStringForKey("gender",unionid);
            UserDefault::getInstance()->setIntegerForKey("openID_y",0);
            cocos2d::LuaEngine::getInstance()->executeGlobalFunction("loginCallBack");

        }
//        exe1FunctionHandler([[WeChatMgr sharedManager] mHandler], "ssiss",nickname.c_str(),headimgurl.c_str(),sex,wx_access_token.c_str(),openid.c_str());

        
        printf("data  = %s",res.c_str());
    }
    
}


void OCTOCManager::requestToken(std::string code){
    // 请求登陆
    std::string path = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=";
    path.append("wx705a56832e439340");
    path.append("&secret=");
    path.append("fc19f05caab667256c6b42783868aee6");
    path.append("&code=");
    
    std::stringstream ss;
    ss<<code;
    std::string s1 = ss.str();
    
    path.append(s1);
    path.append("&grant_type=authorization_code");
    
    
    HttpRequest* request = new (std::nothrow) HttpRequest();
    request->setUrl(path);
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(CC_CALLBACK_2(OCTOCManager::onHttpRequestCompleted, this));
    HttpClient::getInstance()->send(request);
    
}

//#import <UIKit/UIKit.h>
////#import "platform/ios/CCLuaObjcBridge.h"
//
////#import "AppController.h"
////#import "AppDelegate.h"
////#import "RootViewController.h"
//#import "platform/ios/CCEAGLView-ios.h"
//#import "IAPDelegates.h"

@implementation AppController

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

//- (void)onResp:(BaseResp *)resp {
//    BOOL isSendMessageToWXResp = [resp isKindOfClass:[SendMessageToWXResp class]];
//    BOOL isSendAuthResp = [resp isKindOfClass:[SendAuthResp class]];
//    BOOL isAddCardToWXCardPackageResp = [resp isKindOfClass:[AddCardToWXCardPackageResp class]];
//    BOOL isPayResp = [resp isKindOfClass:[PayResp class]];
//    if (isSendMessageToWXResp) {
//
//    } else if (isSendAuthResp) {
//        if(logincodenumber == 0){
//            std::string code1 = [[resp valueForKey:@"code"] UTF8String];
//            OCTOCManager *oc = new OCTOCManager();
//            oc->requestToken(code1);
//            logincodenumber = 1;
//        }
//    } else if (isAddCardToWXCardPackageResp) {
//        if(logincodenumber == 0){
////            std::string code1 = [[resp valueForKey:@"code"] UTF8String];
////            OCTOCManager *oc = new OCTOCManager();
////            oc->requestToken(code1);
////            logincodenumber = 1;
//        }
//    }else if(isPayResp){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//
//        switch (resp.errCode) {
//            case WXSuccess:
//            strMsg = @"支付结果：成功！";
//            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//            break;
//
//            default:
//            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//            break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
//
//}



- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
      
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        
    }
}


- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}


+(int)hasWX{
    BOOL wx = [WXApi isWXAppInstalled];
    if (wx == NO){
        return 0;
    }
    return 1;
    
}

+ (int)isExistenceNetwork
{
    int isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable: isExistenceNetwork = 0;
            break;
        case ReachableViaWWAN: isExistenceNetwork = 1;
            break;
        case ReachableViaWiFi: isExistenceNetwork = 1;
            break;
    }
    return isExistenceNetwork;
}
 
+(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[[SendAuthReq alloc ] init ] autorelease ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"12322222221" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


+(int)payWX:(NSDictionary * )dic{
    PayReq *request = [[[PayReq alloc] init] autorelease];
    request.partnerId = [dic objectForKey:@"partnerId"];
    request.prepayId= [dic objectForKey:@"prepayId"];
    request.package = [dic objectForKey:@"package"];
    request.nonceStr= [dic objectForKey:@"nonceStr"];
    request.timeStamp= [[dic objectForKey:@"timeStamp"] intValue];
    request.sign= [dic objectForKey:@"sign"];
    [WXApi sendReq:request];
    return 1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [UMSocialGlobal shareInstance].type = @"Cocos2d-x";
 
//
    
    [[UMSocialManager defaultManager] openLog:YES];

    [[UMSocialManager defaultManager] setUmSocialAppkey:@"596dd4374ad1564f090016f4"];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx705a56832e439340" appSecret:@"fc19f05caab667256c6b42783868aee6" redirectURL:@"http://mobile.umeng.com/social"];
     [WXApi registerApp:@"wx705a56832e439340" enableMTA:YES];
    //[WXApi registerApp:@"wx705a56832e439340"];
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    
    // Initialize the GLView attributes
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

    // Use RootViewController to manage CCEAGLView
    _viewController = [[RootViewController alloc]init];
    _viewController.wantsFullScreenLayout = YES;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES]; 
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: _viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:_viewController];
    }

    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)_viewController.view);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    //run the cocos2d-x game scene
    app->run();
    
    
    

    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    NSString *URLString = [url absoluteString];
    
    NSString *string = @"niuniu://homenum";
    [WXApi handleOpenURL:url delegate:self];
    if ([URLString rangeOfString:string].location == NSNotFound) {
        NSLog(@"string 不存在 martin");
    } else {
        //NSString *share_roomId=[URLString substringFromIndex:string.length- 6];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:[URLString UTF8String]] forKey:[NSString stringWithUTF8String:"Share_RoomID"]];
        //UserDefault::getInstance()::setStringForKey("Share_RoomID",[share_roomId UTF8String]);
    }
    auto dispatcher = cocos2d::Director::getInstance()->getEventDispatcher();
    if (dispatcher) {
        dispatcher->dispatchCustomEvent("APP_IOS_BACKGROUND_EVENT");
    }
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

 #endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *URLString = [url absoluteString];
    
   NSString *string = @"niuniu://homenum";
    
    if ([URLString rangeOfString:string].location == NSNotFound) {
        NSLog(@"string 不存在 martin");
    } else {
       NSString *share_roomId=[URLString substringFromIndex:string.length- 6];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:[share_roomId UTF8String]] forKey:[NSString stringWithUTF8String:"Share_RoomID"]];
       //UserDefault::getInstance()::setStringForKey("Share_RoomID",[share_roomId UTF8String]);
    }
    
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->pause(); */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->resume(); */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [window release];
    [_viewController release];
    [super dealloc];
}
#endif


@end
