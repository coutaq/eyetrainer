//
//  PurchaseManager.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/7/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseManager : NSObject

@property(nonatomic, readonly) BOOL productIsPurchased;
@property(nonatomic, readonly) BOOL hasTrialTime;

+(PurchaseManager*) sharedInstance;

- (void) provideContent;

@end
