//
//  AnimationViewController.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/19/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PauseViewController.h"
#import "NSGLView.h"

@protocol AnimationViewListener <NSObject>

-(void) launchMain;

@end

@interface AnimationViewController: NSViewController<GLViewListener, PauseViewListener>

@property (nonatomic, strong) NSGLView* glView;
@property (nonatomic, weak_delegate) id<AnimationViewListener> delegate;
@property (nonatomic, strong) PauseViewController* pauseViewController;
@property (nonatomic, assign) BOOL isStopped;

- (id)initWithFrame:(CGRect) frame;
- (void)beginAnimations;
- (void)quitAnimation;
- (void)pauseAnimation;
- (void)toggleAnimation;

@end
