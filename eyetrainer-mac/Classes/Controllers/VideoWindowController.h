//
//  VideoWindowController.h
//  eyetrainer-mac
//
//  Created by Aleksey Kuznetsov on 05.02.14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PauseViewController.h"

@class AVPlayer;

@interface VideoWindowController : NSWindowController <PauseViewListener,NSWindowDelegate>

@property(nonatomic, strong) AVPlayer *player;

@property(nonatomic, strong) PauseViewController* pauseViewController;
@property (nonatomic, assign) BOOL isStopped;

@end
