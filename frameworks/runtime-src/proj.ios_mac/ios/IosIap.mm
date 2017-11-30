
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "IosIap.h"


#include "LuaMgr.h"
#include "AppController.h"
@implementation iAPProductsRequestDelegate

struct lua_State;
-(void)requestData:(NSMutableSet*)set{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

+(int)buyDiamond:(NSDictionary *)dic{
   NSString * tstring = [dic objectForKey:@"buyid"];
   std::string buyids = [tstring UTF8String];
   IOSiAP::pay(buyids);
   return 1;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if (_iosiap->skProducts) {
        [(NSArray *)(_iosiap->skProducts) release];
    }
    // record new product
    _iosiap->skProducts = [response.products retain];
    int count = [response.products count];
//    _iosiap->paymentWithProduct(_iosiap->iosProduct);
    for (int index = 0; index < [response.products count]; index++) {
        SKProduct *skProduct = [response.products objectAtIndex:index];
        
        // check is valid
        bool isValid = true;
        for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
            NSLog(@"invalidIdentifier:%@", invalidIdentifier);
            if ([skProduct.productIdentifier isEqualToString:invalidIdentifier]) {
                isValid = false;
                break;
            }
        }
        
        IOSProduct *iosProduct = new IOSProduct;
        iosProduct->productIdentifier = std::string([skProduct.productIdentifier UTF8String]);
        iosProduct->localizedTitle = std::string([skProduct.localizedTitle UTF8String]);
        iosProduct->localizedDescription = std::string([skProduct.localizedDescription UTF8String]);
        
        // locale price to string
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:skProduct.priceLocale];
        NSString *priceStr = [formatter stringFromNumber:skProduct.price];
        [formatter release];
        iosProduct->localizedPrice = std::string([priceStr UTF8String]);
        
        iosProduct->index = index;
        iosProduct->isValid = isValid;
        _iosiap->iosProduct =iosProduct;
        _iosiap->paymentWithProduct(_iosiap->iosProduct);
        // _iosiap->iOSProducts.push_back(iosProduct);
    }
}



-(void)requestDidFinish:(SKRequest *)request
{
   // _iosiap->delegate->onRequestProductsFinish();
    if (_iosiap->iosProduct == NULL)
    {
//        LuaMgr::exeFunction([AppController getPayFai], "支付失败");
       LuaMgr::exeGlobalFunction("onPayFail","is",0,"1");
        return;
    }
//   _iosiap->paymentWithProduct(_iosiap->iosProduct);
    [request.delegate release];
    [request release];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
   // _iosiap->delegate->onRequestProductsError([error code]);
     LuaMgr::exeGlobalFunction("onPayFail","is",0,"1");
}

@end

@interface iAPTransactionObserver : NSObject<SKPaymentTransactionObserver>
@property (nonatomic, assign) IOSiAP *iosiap;
@end

@implementation iAPTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        std::string identifier([transaction.payment.productIdentifier UTF8String]);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                return;
            case SKPaymentTransactionStatePurchased:
                    [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
         
                break;
            case SKPaymentTransactionStateRestored:
                  [self restoreTransaction:transaction];
                break;
        }
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
    // 交易收据
    NSString * receipt;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version<7){
       receipt = [transaction.transactionReceipt base64Encoding];
    }else{
       receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
    }
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        
        LuaMgr::exeGlobalFunction("onPaySuccess","is",0,[receipt UTF8String]);
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
            LuaMgr::exeGlobalFunction("onPayFail","is",0,"2");
    } else {
        NSLog(@"用户取消交易");
            LuaMgr::exeGlobalFunction("onPayFail","is",0,"3");
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        std::string identifier([transaction.payment.productIdentifier UTF8String]);
    }
}

@end

static IOSiAP	*m_assetsMgr;


IOSiAP * IOSiAP::getIOSIAP()//通过静态公有函数获得该类的实例对象
{
    if(m_assetsMgr == NULL)
        m_assetsMgr=new IOSiAP();
    return m_assetsMgr;
}
IOSiAP::IOSiAP():
iosProduct(nullptr),
skProducts(nullptr),
isValid(false),
vaildNum(0)
{
    skTransactionObserver = [[iAPTransactionObserver alloc] init];
    ((iAPTransactionObserver *)skTransactionObserver).iosiap = this;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:(iAPTransactionObserver *)skTransactionObserver];
}

IOSiAP::~IOSiAP()
{
    if (skProducts) {
        [(NSArray *)(skProducts) release];
    }
    
    delete iosProduct;
    /*
    std::vector <IOSProduct *>::iterator iterator;
    for (iterator = iOSProducts.begin(); iterator != iOSProducts.end(); iterator++) {
        IOSProduct *iosProduct = *iterator;
        delete iosProduct;
    }
    */
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:(iAPTransactionObserver *)skTransactionObserver];
    [(iAPTransactionObserver *)skTransactionObserver release];
}
/*
IOSProduct *IOSiAP::iOSProductByIdentifier(std::string &identifier)
{
    std::vector <IOSProduct *>::iterator iterator;
    for (iterator = iOSProducts.begin(); iterator != iOSProducts.end(); iterator++) {
        IOSProduct *iosProduct = *iterator;
        if (iosProduct->productIdentifier == identifier) {
            return iosProduct;
        }
    }
    
    return nullptr;
}
*/
void IOSiAP::requestProducts(std::vector <std::string> &productIdentifiers)
{
    isValid = false;
    vaildNum = 0;
    NSMutableSet *set = [NSMutableSet setWithCapacity:productIdentifiers.size()];
    std::vector <std::string>::iterator iterator;
    for (iterator = productIdentifiers.begin(); iterator != productIdentifiers.end(); iterator++) {
        [set addObject:[NSString stringWithUTF8String:(*iterator).c_str()]];
    }
    
    
    iAPProductsRequestDelegate *delegate = [[iAPProductsRequestDelegate alloc] init];
    delegate.iosiap = this;
    [delegate requestData:set];
}


void IOSiAP::pay(std::string identifier)
{
    if ([SKPaymentQueue canMakePayments]) {
        std::vector <std::string> productIdentifiers;
        productIdentifiers.push_back(identifier);
        IOSiAP::getIOSIAP()->requestProducts(productIdentifiers);
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        //LuaMgr::exeGlobalFunction("onPayFail","is",0,"用户禁止应用内付费购买");
    }
}



void IOSiAP::paymentWithProduct(IOSProduct *iosProduct, int quantity)
{

//        SKProduct *skProduct = [(NSArray *)(skProducts) objectAtIndex:iosProduct->index];
//        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:skProduct];
//        payment.quantity = quantity;
//
    std::string tproduceId = iosProduct->productIdentifier;
    NSString *produceId = [NSString stringWithCString:tproduceId.c_str()
                                                encoding:[NSString defaultCStringEncoding]];
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:produceId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];


}
