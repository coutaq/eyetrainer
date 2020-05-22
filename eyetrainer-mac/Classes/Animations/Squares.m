//
//  Squares.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/9/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//


#import "Squares.h"
#import "GlobalInfo.h"
#import <math.h>

#define MODE_COLOR 1
#define MODE_ALL 2

@interface Squares()
-(void) onFadeIn;
-(void) onSlideShow;
-(void) onFadeOut;

@end


@implementation Squares

static const float transferTimeComplexed=1000;
static const float transterTimeColored=400;

static const float startSpeed=2*PI;
static const float speedScale=22.5;

static GLfloat red[]={1.0,0.0,0.0,0.0};
static GLfloat green[]={0.0,1.0,0.0,0.0};
static GLfloat blue[]={0.0,0.0,1.0,0.0};
static GLfloat yellow[]={1.0,1.0,0.0,0.0};

static mat4 vMatrix;

-(void) prepare{
    _slideReplaced=false;
    
    _fadeInTime=1500;
    _fadeOutTime=1000;
    
    matrixOrtho(vMatrix);
    
    
    slides = [[NSArray alloc] initWithObjects:
              [[[SquareSlide alloc] init:10500 :70.0:blue :yellow :4 :3] autorelease] ,
              [[[SquareSlide alloc] init:10500 :70.0:green :red :4 :3] autorelease],
              
              [[[SquareSlide alloc] init:10500 :70.0:blue :yellow :8 :6] autorelease],
              [[[SquareSlide alloc] init:10500 :70.0:green :red :8 :6] autorelease],
              
              [[[SquareSlide alloc] init:10500 :70.0:blue :yellow :16 :12] autorelease],
              [[[SquareSlide alloc] init:10500 :70.0:green :red :16 :12] autorelease],nil ];
    
    
    screenHeight=[GlobalInfo SizeFactor];
    screenWidth=[GlobalInfo ScreenWidth]/[GlobalInfo ScreenHeight]*[GlobalInfo SizeFactor];
    
    currentSlide=0;
    distance=0;
    array=[[SquareArray alloc] init];
    [self prepareNextSlide];
    
    [self resetTimeCounter];
}

-(void) draw{
    [super setDrawParams];
}

-(void) reset{
    
}

-(void) dealloc{
    [array release];
    [slides release];
    [super dealloc];
}

-(void) onFadeIn{
    _fadeFactor=_currentTime/_fadeInTime;
    GLfloat newColorA[4];
    GLfloat newColorB[4];
    colorMultiply(((SquareSlide*)[slides objectAtIndex:0]).colorA, _fadeFactor, newColorA);
    colorMultiply(((SquareSlide*)[slides objectAtIndex:0]).colorB, _fadeFactor, newColorB);
    [array draw:vMatrix :newColorA :newColorB : 1.0];
}

-(void) onSlideShow{
    if(!_doTransfer)
    {
    if(_currentTime>slide.time){
        if(currentSlide<[slides count]-1){
            _doTransfer=true;
            [self configureTransferMode];
        }else{
            _slidesFinished=true;
            [self resetTimeCounter];
            return;
        }
        

    }
    currentSpeed=slide.accelerationFactor*_currentTime/slide.time/speedScale+pow(startSpeed,0.33333);
    colorMultiplier=(float) cos(pow(currentSpeed,3.0)*2.0);
    [array draw:vMatrix :slide.colorA :slide.colorB :colorMultiplier];
    }else{
        [self performTransfer];
    }
    
}

-(void) onFadeOut{
    _fadeFactor=(1.0-_currentTime/_fadeOutTime);
    GLfloat newColorA[4];
    GLfloat newColorB[4];
    colorMultiply(((SquareSlide*)[slides objectAtIndex:([slides count]-1)]).colorA, _fadeFactor, newColorA);
    colorMultiply(((SquareSlide*)[slides objectAtIndex:([slides count]-1)]).colorB, _fadeFactor, newColorB);
    [array draw:vMatrix :newColorA :newColorB : 1.0];
}

-(void) prepareNextSlide{
    slide = [slides objectAtIndex:currentSlide];
    float sizeX=screenWidth/slide.countX;
    float sizeY=screenHeight/slide.countY;
    [array setSquaresProperties:sizeX :sizeY :screenWidth/2.0 :screenHeight/2.0 :slide.countX :slide.countY];
    
}

-(void) configureTransferMode{
    SquareSlide *nextSlide = (SquareSlide*) [slides objectAtIndex:currentSlide+1];
    if([slide isEqualTo:nextSlide]){
        _transferMode=MODE_COLOR;
        _transferTime=transterTimeColored;
    }else{
        _transferMode=MODE_ALL;
        _transferTime=transferTimeComplexed;
    }
    _slideReplaced=false;
    [self resetTimeCounter];
    
}

-(void) performTransfer{
    GLfloat colorA[4];
    GLfloat colorB[4];
    GLfloat midColor[4];
    if(_currentTime<_transferTime)
    {
        switch (_transferMode) {
            case MODE_COLOR:
                if(_currentTime<_transferTime/2.0){
                    SquareSlide *nextSlide = (SquareSlide*) [slides objectAtIndex:currentSlide+1];
                    colorMix(slide.colorA, nextSlide.colorA, _currentTime/_transferTime, colorA);
                    colorMix(slide.colorB, nextSlide.colorB, _currentTime/_transferTime, colorB);
                }else{
                    if(!_slideReplaced){
                        currentSlide++;
                        [self prepareNextSlide];
                        _slideReplaced=true;
                    }
                    SquareSlide *previousSlide = (SquareSlide*) [slides objectAtIndex:currentSlide-1];
                    colorMix( previousSlide.colorA, slide.colorA, _currentTime/_transferTime, colorA);
                    colorMix( previousSlide.colorB, slide.colorB,_currentTime/_transferTime, colorB);
                    
                    
                }
                break;
            case MODE_ALL:
                if(_currentTime<_transferTime/2.0){
                    SquareSlide *nextSlide = (SquareSlide*) [slides objectAtIndex:currentSlide+1];
                    colorMix(slide.colorA,slide.colorB,0.5,colorA);
                    colorMix(nextSlide.colorA,nextSlide.colorB,0.5,colorB);
                    colorMix(colorA,colorB,_currentTime/_transferTime, midColor);
                    colorMix(slide.colorA, midColor, _currentTime/_transferTime*2.0, colorA);
                    colorMix(slide.colorB, midColor, _currentTime/_transferTime*2.0, colorB);
                    
                }else{
                    if(!_slideReplaced){
                        currentSlide++;
                        [self prepareNextSlide];
                        _slideReplaced=true;
                    }
                    SquareSlide *previousSlide = (SquareSlide*) [slides objectAtIndex:currentSlide-1];
                    colorMix(previousSlide.colorA,previousSlide.colorB,0.5,colorA);
                    colorMix(slide.colorA,slide.colorB,0.5,colorB);
                    colorMix(colorA,colorB,_currentTime/_transferTime, midColor);
                    colorMix(midColor, slide.colorA, _currentTime/_transferTime*2.0-1.0, colorA);
                    colorMix(midColor, slide.colorB, _currentTime/_transferTime*2.0-1.0, colorB);
                }
                
                break;
                
            default:
                break;
                
        }
        [array draw:vMatrix :colorA :colorB :1.0];
        
    }else{
        _doTransfer=false;
        [array draw:vMatrix :slide.colorA :slide.colorB :1.0];
        [self resetTimeCounter];
    }
}

-(void) releaseOpenglResources{
    [array releaseOpenglResources];
}

-(double) step:(double)x{
    return (cos(x)+cos(3.0*x)*0.3)*0.8;
}

@end
