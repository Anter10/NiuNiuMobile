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

#include "cocos2d.h"


#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"
USING_NS_CC;
using namespace cocos2d::network;

class OCTOCManager{
    public:
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


#import <UIKit/UIKit.h>
#include "WXApi.h"

@class RootViewController;

@interface AppController : NSObject <UIApplicationDelegate, WXApiDelegate> {

}
+(void)sendAuthRequest;
+(int)hasWX;
+(int)isExistenceNetwork;
+(int)payWX:(NSDictionary *)dic;

@property(nonatomic, readonly) RootViewController* viewController;

@end


//@class RootViewController;
//
//@interface AppController : NSObject <UIApplicationDelegate>
//{
//    UIWindow *window;
//    RootViewController *viewController;
//}
////skProducts would be called outside the class
//@property (nonatomic, assign) NSArray *skProducts;
//
//- (void) onPaymentEvent:(NSString *)productId andQuantity:(NSInteger)count;
//@end

