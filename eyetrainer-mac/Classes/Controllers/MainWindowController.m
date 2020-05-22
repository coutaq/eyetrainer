//
//  MainWindowController.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "MainWindowController.h"
#import "iRate.h"
#import "NSWindow+Fade.h"
#import "PurchaseManager.h"
#import "StatsTracker.h"
#import "iRate.h"

@interface MainWindowController ()
@property (nonatomic, assign) BOOL showPurchase;

@end

@implementation MainWindowController

-(void) awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
    
    [self.window setBackgroundColor:[NSColor blackColor]];
    [self launchMain];
    [self.window setTitle:NSLocalizedString(@"app_name", nil)];

    self.showPurchase = NO;
}

- (BOOL)canPlayAnimation
{
    return ([PurchaseManager sharedInstance].productIsPurchased || [StatsTracker single].appUsageAllowed);
}


-(void) launchMain {
    if (([self.window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask) {
        [self.window toggleFullScreen:self];
    }
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorDefault];
    [NSCursor unhide];

    MainViewController *controller = [[MainViewController alloc] initWithNibName:kMainViewController bundle:nil];
    [self.window.contentView addSubview:controller.view];
    [self setupConstarints:controller.view];
    controller.delegate = self;
    [self removeCurrentView];
    self.currentController = controller;
    [controller.view setFrame: [self.window.contentView bounds]];
}

-(void) launchAnimations {
    if (self.canPlayAnimation) {
        [self.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        
        NSRect screenFrame = [[NSScreen mainScreen] frame];
        CGFloat kFullScreenFrame= kRatedHeight/screenFrame.size.height;
        NSRect fullScreenFrame = CGRectMake(0, 0, kRatedWidth/kFullScreenFrame, screenFrame.size.height);
        
        //do not change order.
        AnimationViewController *controller = [[AnimationViewController alloc] initWithFrame:fullScreenFrame];
        [self.window.contentView addSubview:controller.view];
        [self setupConstarints:controller.view];
        controller.delegate = self;
        [self removeCurrentView];
        self.currentController = controller;
        [NSCursor hide];

        [self.window toggleFullScreen:self];
        
        [self.window setFrame:fullScreenFrame display:NO animate:NO];
        [self.window center];
        [controller.view setFrame: [self.window.contentView bounds]];
    }else{
        [self launchPurchase];
    }
}

-(void)launchVideo
{
    self.videoWindowController = [[VideoWindowController alloc] initWithWindowNibName:kVideoWindowController];
    [self.videoWindowController showWindow:self];
}

-(void)launchHelp
{
    self.helpWindowController = [[HelpWindowController alloc] initWithWindowNibName:kHelpWindowController];
    self.helpWindowController.delegate = self;
    [self.helpWindowController showWindow:self];
}

- (void)launchFeedback
{
#if APP_IN_DEBUG == 1
    [StatsTracker clearingNSUserDefaults];
#else
    NSString *mailtoAddress = [NSString stringWithFormat:@"mailto:%@?Subject=%@",APP_EMAIL,APP_EMAIL_SUBJ];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mailtoAddress]];
#endif
}

-(void) launchReminder{
    self.reminderWindowController= [[ReminderWindowController alloc] initWithWindowNibName:kReminderWindowController];;
    [self.reminderWindowController.window makeKeyWindow];
}

-(void) launchPurchase{
    if (!self.purchaseViewController) {
        self.purchaseViewController = [[PurchaseWindowController alloc] initWithWindowNibName:kPurchaseWindowController];
        [[NSApplication sharedApplication] beginSheet:self.purchaseViewController.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(purchaseDidEnd) contextInfo:nil];
    }
}

-(void) purchaseDidEnd{    
    [self.purchaseViewController.window close];
    self.purchaseViewController = nil;
}

-(void) removeCurrentView {
    if ([self.currentController view] != nil) {
		[[self.currentController view] removeFromSuperview];
    }
}

-(void) setupConstarints:(NSView*)customView {
    //custom view resize to the window
    NSView *contentView = [self.window contentView];
    [customView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = NSDictionaryOfVariableBindings(customView);
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

#pragma mark - NSWindowDelegate

-(void)windowWillExitFullScreen:(NSNotification *)notification{
    if([self.currentController isKindOfClass:[AnimationViewController class]]){
        
        // this method also calls launchMain, so main vc will also appear
        [((AnimationViewController*) self.currentController) quitAnimation];
    }
}

-(void)windowDidEnterFullScreen:(NSNotification *)notification{
    if([self.currentController isKindOfClass:[AnimationViewController class]]){
        [((AnimationViewController*) self.currentController) beginAnimations];
    }
}

-(void)windowDidExitFullScreen:(NSNotification *)notification{
    if([self.currentController isKindOfClass:[MainViewController class]]){
        if ([PurchaseManager sharedInstance].productIsPurchased) {
            [[iRate sharedInstance] logEvent:NO];
        } else {
            [self launchPurchase];
        }
    }
}

- (void)windowDidResignKey:(NSNotification *)notification{
    if([self.currentController isKindOfClass:[AnimationViewController class]]){
        [((AnimationViewController*) self.currentController) pauseAnimation];
    }
}

- (BOOL)windowShouldClose:(id)sender{
    [self.window fadeOut:self];
    return NO;
}

#pragma mark - NSNotification

-(void) windowClose:(NSNotification*)notification {
    
    if ([notification object] == self.reminderWindowController.window) {
        self.reminderWindowController = nil;
    }
    if ([notification object] == self.helpWindowController.window) {
        self.helpWindowController = nil;
    }
    if ([notification object] == self.videoWindowController.window) {
        self.videoWindowController = nil;
    }
    
    // If closed mainWindow, close all.
    if ([notification object] == self.window) {
        if (self.helpWindowController) {
            [self.helpWindowController close];
        }
        if (self.videoWindowController) {
            [self.videoWindowController close];
            
        }
        if (self.reminderWindowController){
            [self.reminderWindowController close];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSResponder

- (void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == 36 || [theEvent keyCode] == 49 ) {
        if([self.currentController isKindOfClass:[AnimationViewController class]]){
            [((AnimationViewController*) self.currentController) toggleAnimation];
        }
        if([self.currentController isKindOfClass:[MainViewController class]] && self.canPlayAnimation){
            [self launchAnimations];
        }
    }
    if ([theEvent keyCode] == 12) {
        [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
    }
}




@end
