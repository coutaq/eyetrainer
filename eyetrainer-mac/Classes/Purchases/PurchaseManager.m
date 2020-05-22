//
//  PurchaseManager.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/7/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "PurchaseManager.h"
#import "STKeychain.h"

@implementation PurchaseManager

+ (PurchaseManager *)sharedInstance
{
    static PurchaseManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PurchaseManager new];
    });
    return sharedInstance;
}

- (BOOL)productIsPurchased
{
#if APP_IN_DEBUG == 1
    return YES;
#else
    NSString* name = [NSBundle mainBundle].bundleIdentifier;
    NSError* error;
    NSString* isPurchased = [STKeychain getPasswordForUsername: name andServiceName:name error:&error];
    return nil!=isPurchased;
#endif
}

- (void)provideContent
{
    NSString* name = [NSBundle mainBundle].bundleIdentifier;
    NSError* error;
    [STKeychain storeUsername:name andPassword:@"YES" forServiceName:name updateExisting:YES error:&error];
}

@end
