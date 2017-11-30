//
//  IosIap.hpp
//  qiqigame
//
//  Created by xtgg on 15/10/15.
//
//

#ifndef IosIap_hpp
#define IosIap_hpp
#include <iostream>
#include <vector>
#include <StoreKit/StoreKit.h>
class IOSProduct
{
public:

    std::string productIdentifier;
    std::string localizedTitle;
    std::string localizedDescription;
    std::string localizedPrice;// has be localed, just display it on UI.
    bool isValid;
    int index;//internal use : index of skProducts
};

class IOSiAP
{
public:
    static IOSiAP * getIOSIAP();
    IOSiAP();
    ~IOSiAP();
    
    void requestProducts(std::vector <std::string> &productIdentifiers);
    IOSProduct *iOSProductByIdentifier(std::string &identifier);
    void paymentWithProduct(IOSProduct *iosProduct, int quantity = 1);
    bool isValid;
    int vaildNum;
    static void pay(std::string identifier);
    
    // ===  internal use for object-c class ===
    void *skProducts;// object-c SKProduct
    void *skTransactionObserver;// object-c TransactionObserver
    
    IOSProduct* iosProduct;
    //std::vector<IOSProduct *> iOSProducts;
};

@interface iAPProductsRequestDelegate : NSObject<SKProductsRequestDelegate>
    @property (nonatomic, assign) IOSiAP *iosiap;

+(int)buyDiamond:(NSDictionary *)dic;
@end


#endif

