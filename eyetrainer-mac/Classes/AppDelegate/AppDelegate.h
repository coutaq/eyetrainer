//
//  AppDelegate.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (unsafe_unretained) IBOutlet MainWindowController *mainWindowController;

@end
