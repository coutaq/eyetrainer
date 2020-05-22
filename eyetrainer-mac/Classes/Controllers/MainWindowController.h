//
//  MainWindowController.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"
#import "AnimationViewController.h"
#import "PauseViewController.h"
#import "AppDelegate.h"
#import "HelpWindowController.h"
#import "VideoWindowController.h"
#import "ReminderWindowController.h"
#import "PurchaseWindowController.h"

@interface MainWindowController : NSWindowController<AnimationViewListener, MainViewListener, HelpWindowDelegate, NSWindowDelegate>

@property(nonatomic, strong) NSViewController* currentController;
@property(nonatomic, strong) HelpWindowController *helpWindowController;
@property(nonatomic, strong) VideoWindowController *videoWindowController;
@property(nonatomic, strong) ReminderWindowController *reminderWindowController;
@property(nonatomic, strong) PurchaseWindowController *purchaseViewController;

@end
