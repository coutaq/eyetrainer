//
//  AnimationViewController.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/19/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "AnimationViewController.h"
#import "StatsTracker.h"
#import <IOKit/pwr_mgt/IOPMLib.h>
#import "PurchaseManager.h"
#import "StatsTracker.h"
#import "iRate.h"

@interface AnimationViewController ()

@property (nonatomic, assign) IOPMAssertionID assertionID;
@property (nonatomic, assign) IOReturn success;
@end

@implementation AnimationViewController

- (id)initWithFrame:(CGRect) frame
{
    self = [super init];
    if (self) {
        
        NSOpenGLPixelFormatAttribute attrs[] =
        {
            NSOpenGLPFADoubleBuffer,
            0
        };
        NSOpenGLPixelFormat* format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
        
        NSOpenGLContext* context = [[NSOpenGLContext alloc] initWithFormat:format shareContext:nil];
        self.glView = [[NSGLView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        [self.glView setPixelFormat:format];
        [self.glView setOpenGLContext:context];
        
        self.glView.delegate = self;
        self.glView.acceptsTouchEvents=YES;
        [self.view addSubview:self.glView];
    }

    return self;
}

-(void) loadView{
    self.view = [[NSView alloc] init];
}

-(void) stop{
    
    self.isStopped = YES;
    [self.glView stop];
}

-(void) resume{
    self.isStopped = NO;
    [self.glView resume];
}

-(void) view:(NSView *)view clickedWithEvent:(NSEvent *)event{
    [self toggleAnimation];
}

-(void) toggleAnimation{
    if(self.isStopped){
        [self resume];
        [self hidePauseDialog];
    }else{
        [self stop];
        [self showPauseDialog];
    }
}

-(void) pauseAnimation{
    if(!self.isStopped){
        [self stop];
        [self showPauseDialog];
    }
}

-(void) animationOver{
    [[StatsTracker single] animationDidFinish];
    [self performSelectorOnMainThread:@selector(quitAnimation) withObject:nil waitUntilDone:NO];
}

-(void)beginAnimations{
    [self noDisplaySleep];
    [self.glView setFrame: [self.view bounds]];
    [self resume];
}

-(void) noDisplaySleep {
    CFStringRef reasonForActivity= CFSTR("Play Animation");
    IOPMAssertionID aAssertionID;
    self.success = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep,
                                                   kIOPMAssertionLevelOn, reasonForActivity, &aAssertionID);
    self.assertionID = aAssertionID;
}

-(void) clearAnim{
    [self.glView stop];
    if(self.delegate){
        [self.delegate launchMain];
    }
}

-(void) showPauseDialog{
    [NSCursor unhide];
    self.pauseViewController = [[PauseViewController alloc] initWithNibName:kPauseViewController bundle:nil];
    [self.pauseViewController.view setFrame:self.view.frame];
    [self.pauseViewController.view setWantsLayer:YES];
    [self.view addSubview:self.pauseViewController.view];
    self.pauseViewController.delegate = self;
}

-(void) hidePauseDialog{
    [NSCursor hide];
    if(self.pauseViewController){
        [self.pauseViewController.view removeFromSuperview];
        self.pauseViewController = nil;
    }
    [self.view setNeedsDisplay:YES];
}

-(void) quitAnimation{
    self.success = IOPMAssertionRelease(self.assertionID);
    if(self.isStopped){
        [self hidePauseDialog];
    }
    if(self.delegate){
        [self.delegate launchMain];
    }
}

-(void) resumeAnimation{
    [self hidePauseDialog];
    [self resume];
}

-(void) dealloc{
    self.view = nil;
    self.glView = nil;
    self.delegate = nil;
    self.pauseViewController = nil;
}

@end
