//
//  PauseViewController.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/20/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PauseViewListener <NSObject>

-(void) resumeAnimation;
-(void) quitAnimation;

@end

@interface PauseViewController : NSViewController
@property(nonatomic, weak_delegate) id<PauseViewListener> delegate;

@end
