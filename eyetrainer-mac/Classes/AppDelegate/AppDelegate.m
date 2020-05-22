//
//  AppDelegate.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "StatsTracker.h"
#import "iRate.h"
#import "PurchaseManager.h"

@implementation AppDelegate

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].usesUntilPrompt = 99;
    [iRate sharedInstance].remindPeriod = 0;

    [iRate sharedInstance].eventsUntilPrompt = 3;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
#if APP_IN_DEBUG == 1
    [iRate sharedInstance].applicationBundleID = @"com.charcoaldesign.RainbowBlocksLite";
#endif

}

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

    NSUserNotification *userNotification = notification.userInfo[NSApplicationLaunchUserNotificationKey];
    if (userNotification) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:userNotification];
    }
    
    if(![[StatsTracker single] isVideoWatched]){
        [self.mainWindowController launchVideo];
    } else {
        [self.mainWindowController launchMain];
        [self.mainWindowController.window makeMainWindow];
        [self.mainWindowController.window makeKeyWindow];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationWillBecomeActive:(NSNotification *)aNotification
{
    NSLog(@"applicationWillBecomeActive");
    [[StatsTracker single] track];
}

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    [center removeDeliveredNotification: notification];
}

#pragma mark - iRate delegate methods

- (void)iRateUserDidRequestReminderToRateApp
{
    [iRate sharedInstance].eventCount = 0;
}

@end
