//
//  NSWindow+Fade.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/17/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "NSWindow+Fade.h"

#define kWindowAnimationDuration 0.2f

@implementation NSWindow (Fade)

- (void)fadeIn:(id)sender
{
    [self setAlphaValue:0.3f];
    [self makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kWindowAnimationDuration];
    [[self animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (void)fadeOut:(id)sender
{
    [NSAnimationContext beginGrouping];
    NSWindow *bself = self;
    [[NSAnimationContext currentContext] setDuration:kWindowAnimationDuration];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [bself close];
    }];
    [[self animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

@end
