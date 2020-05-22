//
//  PurchasePanel.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/7/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PurchaseWindowController : NSWindowController

@property (strong) IBOutlet NSTextField *contentLabel;
@property (strong) IBOutlet NSButton *buyButton;
@property (strong) IBOutlet NSButton *restoreButton;
@property (strong) IBOutlet NSButton *cancelButton;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@property (strong) IBOutlet NSTextField *progressLabel;

- (void)showProgressWithStatus:(NSString*) status;
- (void)hideProgress;

@end
