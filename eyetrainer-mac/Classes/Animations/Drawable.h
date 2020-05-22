//
//  Drawable.h
//  gg
//
//  Created by Denys Nikolayenko on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "imageUtil.h"

#define PI 3.141592653589f
#define TWOPI 6.28318530718f

@interface Drawable : NSObject{
    @protected
    BOOL _fadedIn;
    BOOL _slidesFinished;
    float _fadeFactor;
    float _currentTime;
    float _savedTime;
    NSDate *start;
    int _fadeInTime;
    int _fadeOutTime;
}
@property (readwrite)BOOL animationFinished;

-(id) init;
-(void) prepare;
-(void) draw;
-(void) pause;
-(void) resume;
-(void) setDrawParams;
-(void) releaseOpenglResources;

-(void) onFadeIn;
-(void) onSlideShow;
-(void) onFadeOut;


-(void) resetTimeCounter;

@end
