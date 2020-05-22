//
//  VideoWindowController.m
//  eyetrainer-mac
//
//  Created by Aleksey Kuznetsov on 05.02.14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "VideoWindowController.h"
#import "NSWindow+Fade.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoWindowController ()

@end

@implementation VideoWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSString* moviePathStr = [[NSBundle mainBundle] pathForResource:@"instruct" ofType:@"mp4"];
    
    self.player = [[AVPlayer alloc] init];
    AVURLAsset *file = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:moviePathStr isDirectory:NO]];
    
    [file loadValuesAsynchronouslyForKeys:nil completionHandler:^(void) {
        
        // The asset invokes its completion handler on an arbitrary queue when loading is complete.
        // Because we want to access our AVPlayer in our ensuing set-up, we must dispatch our handler to the main queue.
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            // Create an AVPlayerLayer and add it to the player view if there is video, but hide it until it's ready for display
            
            AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            [newPlayerLayer setFrame:[[self.window.contentView layer] bounds]];
            [newPlayerLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
            [[self.window.contentView layer] addSublayer:newPlayerLayer];
            
            // Create a new AVPlayerItem and make it our player's current item.
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:file];
            [self.player replaceCurrentItemWithPlayerItem:playerItem];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didPlayToEndTime:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:playerItem];
            [self.player play];
        });
        
    }];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.window setTitle:NSLocalizedString(@"hv_video", nil)];
    
    CGRect windowFrame = CGRectApplyAffineTransform([NSScreen mainScreen].frame,CGAffineTransformMakeScale(0.8, 0.8));
    [self.window setFrame:windowFrame display:NO animate:NO];
    [self.window center];

    [self.window fadeIn:self];
}

-(void) stop{
    self.isStopped = YES;
    [self.player pause];
}

-(void) resume{
    self.isStopped = NO;
    [self.player play];
}

-(void) showPauseDialog{
    self.pauseViewController = [[PauseViewController alloc] initWithNibName:kPauseViewController bundle:nil];
    [self.pauseViewController.view setFrame:[self.window.contentView frame]];
    [self.pauseViewController.view setWantsLayer:YES];
    [self.window.contentView addSubview:self.pauseViewController.view];
    self.pauseViewController.delegate = self;
}

-(void) hidePauseDialog{
    if(self.pauseViewController){
        [self.pauseViewController.view removeFromSuperview];
        self.pauseViewController = nil;
    }
}

-(void) quitAnimation{
    [self hidePauseDialog];
    [self.window performClose:nil];
}

-(void) resumeAnimation{
    [self hidePauseDialog];
    [self resume];
}

-(void)mouseDown:(NSEvent *)theEvent {
    if(self.isStopped){
        [self resume];
        [self hidePauseDialog];
    }else{
        [self stop];
        [self showPauseDialog];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) didPlayToEndTime:(NSNotification*)notification {
    [self.window performClose:nil];
}

-(BOOL)windowShouldClose:(id)sender{
    [[self player] pause];
    
    [self.window fadeOut:self];
    return NO;
}

@end
