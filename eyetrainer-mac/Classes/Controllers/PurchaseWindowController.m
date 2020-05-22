//
//  PurchasePanel.m
//
//
//  Created by Denys Nikolayenko on 2/7/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "PurchaseWindowController.h"
#import "NSAttributedString+Utils.h"
#import <StoreKit/StoreKit.h>
#import "PurchaseManager.h"
#import "StatsTracker.h"


@interface PurchaseWindowController () <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProductsRequest* productRequest;

@end

@implementation PurchaseWindowController

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.progressLabel setHidden:YES];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    NSString* title;
    if([StatsTracker single].appUsageAllowed){
        title = NSLocalizedString(@"mv_purchase_app", nil);
    } else {
        title = [NSString stringWithFormat:NSLocalizedString(@"mv_trial_expired", nil), APP_DEFAULT_PRICE];
    }
    
    [self.contentLabel setAttributedStringValue:[NSAttributedString stringWithString:title andFont:[NSFont systemFontOfSize:20.]  ofColor:[NSColor blackColor]]];

    [self.restoreButton setTitle:NSLocalizedString(@"mv_restore_purchase", nil)];
    [self.cancelButton setTitle:NSLocalizedString(@"ac_cancel", nil)];
    [self.buyButton setTitle:NSLocalizedString(@"mv_trial_get_full", nil)];
    
    [self.buyButton setTarget:self];
    [self.restoreButton setTarget:self];
    [self.cancelButton setTarget:self];
    [self.buyButton setAction:@selector(buyPressed)];
    [self.restoreButton setAction:@selector(restorePressed)];
    [self.cancelButton setAction:@selector(cancelPressed)];
}

-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    if(nil!=self.productRequest){
        [self.productRequest cancel];
        self.productRequest = nil;
    }
}

- (void)showProgressWithStatus:(NSString *)status{
    [self.contentLabel setHidden:YES];
    [self.restoreButton setEnabled:NO];
    [self.buyButton setEnabled:NO];
    
    [self.progressLabel setHidden:NO];
    [self.progressIndicator startAnimation:self];
    [self.progressLabel setStringValue:status];
}

- (void)hideProgress{
    [self.contentLabel setHidden:NO];
    [self.restoreButton setEnabled:YES];
    [self.buyButton setEnabled:YES];
    
    [self.progressLabel setHidden:YES];
    [self.progressIndicator stopAnimation:self];
}

- (void)setContentLabelErrorString:(NSString*) string{
    NSAttributedString* attributedString = [NSAttributedString stringWithString:string andFont:[NSFont systemFontOfSize:18.] ofColor:[NSColor redColor]];
    [self.contentLabel setAttributedStringValue:attributedString];
}

- (void)buyPressed{
//- (IBAction)buyButtonPressed:(NSButton *)sender {
    [self requestProduct];
}

- (void)restorePressed{
//- (IBAction)restoreButtonPressed:(NSButton *)sender {
    [self showProgressWithStatus:NSLocalizedString(@"mv_restoring_purchases", nil)];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)cancelPressed{
//- (IBAction)cancelButtonPressed:(NSButton *)sender {
    [[NSApplication sharedApplication] endSheet:self.window];
}

- (void)requestProduct{
    [self showProgressWithStatus:NSLocalizedString(@"mv_requesting_product", nil)];
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductName]];
    self.productRequest.delegate = self;
    [self.productRequest start];
}

- (void)purchaseProduct:(SKProduct*) product{
    [self showProgressWithStatus:NSLocalizedString(@"mv_processing_purchase", nil)];
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment: payment];
    //TODO: store transaction state somewhere
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:[NSNumber numberWithInt:TransactionStatePending] forKey:lastTransactionStateKey];
}

- (void)purchaseSucceeded{
    [self hideProgress];
    NSString* title = NSLocalizedString(@"mv_purchase_successful", nil);
    [self.contentLabel setAttributedStringValue:[NSAttributedString stringWithString:title andFont:[NSFont systemFontOfSize:20.]  ofColor:[NSColor blackColor]]];
    [self.restoreButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.buyButton setTitle:NSLocalizedString(@"hv_close", nil)];
    [self.buyButton setAction:@selector(cancelPressed)];
}

- (void)purchaseRestored{
    [self hideProgress];
    NSString* title = NSLocalizedString(@"mv_restore_successful", nil);
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[NSAttributedString stringWithString:title andFont:[NSFont boldSystemFontOfSize:20.] ofColor:[NSColor blackColor]]];
    [self.contentLabel setAttributedStringValue:attributedString];
    [self.restoreButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.buyButton setTitle:NSLocalizedString(@"hv_close", nil)];
    [self.buyButton setAction:@selector(cancelPressed)];
}

- (void)purchaseFailed{
    [self hideProgress];
}

- (void)recordTransaction:(SKPaymentTransaction*) transaction{
    
}

- (void)provideContent:(SKPaymentTransaction*) transaction{
    if([transaction.payment.productIdentifier isEqualToString:kProductName]){
        [[PurchaseManager sharedInstance]provideContent];
        NSLog(@"contentProvided");
    }
}

- (void)finishTransaction:(SKPaymentTransaction*) transaction{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(NSString*) describeError:(NSInteger) errorCode
{
    NSLog(@"%ld", errorCode);
    switch (errorCode) {
        case SKErrorUnknown:
            return NSLocalizedString(@"err_unknown",nil);
        case SKErrorClientInvalid:
            return @"Client is not allowed to perform purchase";                              // client is not allowed to issue the request, etc.
        case SKErrorPaymentInvalid:
            return @"Payment parameters were not recognized";                              // purchase identifier was invalid, etc.
        case SKErrorPaymentNotAllowed:
            return @"Client is not allowed to authorize payments";                              // this device is not allowed to make the payment
        default:
            return NSLocalizedString(@"err_unknown",nil);
    }
    
    return NSLocalizedString(@"err_unknown",nil);
}

#pragma mark - SKProductsRequestDelegate, SKRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    SKProduct* product = nil;
    
    if(response.products.count>0)
    {
        for (SKProduct* aProduct in response.products) {
            if([aProduct.productIdentifier isEqualToString:kProductName])
            {
                
                product = aProduct;
                break;
            }
        }
    }else{
        NSLog(@"Purchase: no products received");
    }
    if(nil==product){
        [self hideProgress];
        [self setContentLabelErrorString:NSLocalizedString(@"mv_product_request_failed", nil)];
    }else{
        [self purchaseProduct:product];
    }
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self hideProgress];
    NSLog(@"Product request failure: %@", error);
    [self setContentLabelErrorString:NSLocalizedString(@"mv_product_request_failed", nil)];
}

-(void)requestDidFinish:(SKRequest *)request{
    if([request isKindOfClass:[SKProductsRequest class]]){
        request = nil;
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchase_success");
                [self recordTransaction:transaction];
                [self provideContent:transaction];
                [self finishTransaction:transaction];
                [self purchaseSucceeded];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase_failed");
                if(transaction.error.code != SKErrorPaymentCancelled)
                {
                    [self setContentLabelErrorString:[self describeError:transaction.error.code]];
                }
                [self finishTransaction:transaction];
                [self purchaseFailed];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Purchase_restored");
                [self recordTransaction:transaction];
                [self provideContent:transaction];
                [self finishTransaction:transaction];
                [self purchaseRestored];
            default:
                break;
                
        }
        
    }
}

- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [self hideProgress];
    if(error.code != SKErrorPaymentCancelled)
    {
        [self setContentLabelErrorString:[self describeError:error.code]];
    }
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [self purchaseRestored];
}

@end
