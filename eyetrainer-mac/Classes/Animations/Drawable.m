//
//  Drawable.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Drawable.h"
#import "Utils.h"

@implementation Drawable

@synthesize animationFinished;

-(id) init{
    self=[super init];
    if(self!=nil)
    {
        animationFinished=false;
        _fadedIn=false;
        _slidesFinished=false;
    }
    return self;
}

-(void) prepare{
    
}

-(void) draw{
}

-(void) pause{
    _savedTime=_currentTime;
}

-(void) resume{
    [self restartTimeCounter];
}

-(void) setDrawParams{
    
    _currentTime = [start timeIntervalSinceNow]*(-1000)+_savedTime;
    
    if(!_fadedIn){
        if(_currentTime<=_fadeInTime){
            [self onFadeIn];
        } else {
            _fadedIn=true;
            [self resetTimeCounter];
            _savedTime=0;
        }
    }
    if(_fadedIn && !_slidesFinished){
        [self onSlideShow];
    }
    if(_slidesFinished){
        if(_currentTime<_fadeOutTime){
            [self onFadeOut];
        } else {
            animationFinished=true;
        }
    }
}

-(void) resetTimeCounter{
    [self restartTimeCounter];
    _savedTime=0;
}

-(void) restartTimeCounter{
    if(start){
        [start release];
        start=nil;
    }
    start =[[NSDate date] retain];
    _currentTime = [start timeIntervalSinceNow]*(-1000);
}

-(void) releaseOpenglResources{
    
}

-(void) onFadeIn{
    
}
-(void) onSlideShow{
    
}
-(void) onFadeOut{
    
}


-(void) dealloc{
    [start release];
    [super dealloc];
}

@end
