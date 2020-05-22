//
//  HelpWindowController.h
//  eyetrainer-mac
//
//  Created by Aleksey Kuznetsov on 30.01.14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol HelpWindowDelegate <NSObject>

-(void) launchVideo;

@end

@interface HelpWindowController : NSWindowController <NSWindowDelegate>

@property(nonatomic,weak_delegate) id<HelpWindowDelegate> delegate;

@property (weak) IBOutlet NSTextField *textInfo;
@property (weak) IBOutlet NSTextField *labelHintPose;
@property (weak) IBOutlet NSTextField *labelHintIpad;
@property (weak) IBOutlet NSTextField *labelHintButton;
@property (weak) IBOutlet NSTextField *labelHintEyesight;
@property (weak) IBOutlet NSTextField *labelDisclaimer;
@property (weak) IBOutlet NSTextField *textDisclaimer;
@property (weak) IBOutlet NSButton *btnVideo;

@end
