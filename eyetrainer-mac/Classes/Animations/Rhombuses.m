//
//  Rhombuses.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Rhombuses.h"
#import "GlobalInfo.h"

#define MODE_COLOR 1
#define MODE_ALL 2

@interface Rhombuses()

-(void) onFadeIn;
-(void) onSlideShow;
-(void) onFadeOut;

@end

@implementation Rhombuses

static const float transferTimeComplexed=1000;
static const float transterTimeColored=400;

static const float speedScale=4.0f;

static float screenWidth;
static float screenHeight;

static GLfloat red[]={1.0,0.0,0.0,0.0};
static GLfloat green[]={0.0,1.0,0.0,0.0};
static GLfloat blue[]={0.0,0.0,1.0,0.0};
static GLfloat yellow[]={1.0,1.0,0.0,0.0};



static mat4 vMatrix;


-(void) prepare{
    matrixOrtho(vMatrix);
    
    _slideReplaced=false;
    
    _fadeInTime=1500;
    _fadeOutTime=1500;
    
    
    slides = [[NSArray alloc] initWithObjects:
              [[[RhombusSlide alloc]init:6000 :blue:yellow :1.125 :8 :4 :3] autorelease],
              [[[RhombusSlide alloc]init:6000 :green:red:1.125 :-8 :4 :3] autorelease],
              [[[RhombusSlide alloc]init:6000 :blue:yellow :3.125 :16 :4 :3] autorelease],
              [[[RhombusSlide alloc]init:6000 :green:red :3.125 :-16 :4 :3] autorelease],
              
              [[[RhombusSlide alloc]init:6000 :blue:yellow  :1.125 :8 :8 :6] autorelease],
              [[[RhombusSlide alloc]init:6000 :green:red :1.125 :-8 :8 :6] autorelease],
              [[[RhombusSlide alloc]init:6000 :blue:yellow  :3.125 :16 :8 :6] autorelease],
              [[[RhombusSlide alloc]init:6000 :green:red :3.125 :-16 :8 :6] autorelease],
              
              [[[RhombusSlide alloc]init:6000 :blue:yellow :1.125 :8 :16 :12] autorelease],
              [[[RhombusSlide alloc]init:6000 :green:red :1.125 :-8 :16 :12] autorelease], nil ];
    
    screenHeight=[GlobalInfo SizeFactor];
    screenWidth=[GlobalInfo ScreenWidth]/[GlobalInfo ScreenHeight]*[GlobalInfo SizeFactor];
    array = [[RhombusArray alloc] init];
    currentSlide=0;
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

-(void) prepareNextSlide{
    slide = [slides objectAtIndex:currentSlide];
    float sizeX=screenWidth/slide.countX;
    float sizeY=screenHeight/slide.countY;
    [array setRhombusesParameters:sizeX :sizeY :screenWidth/2.0 :screenHeight/2.0 :slide.countX :slide.countY :slide.tiles];
}

-(void) onFadeIn{
    _fadeFactor=_currentTime/_fadeInTime;
    RhombusSlide *current = [slides objectAtIndex:currentSlide];
    [array draw: vMatrix: current.colorA:current.colorB: 0.0: _fadeFactor];
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
        float offset=(sin((_currentTime/slide.time-0.5)*PI)+1.0)*slide.speed/2.0;
        [array draw:vMatrix:slide.colorA:slide.colorB: offset:1.0];
    }else{
        [self performTransfer];
    }

}

-(void) configureTransferMode{
    RhombusSlide *nextSlide = (RhombusSlide*) [slides objectAtIndex:currentSlide+1];
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
    GLfloat colorA[4];//=(GLfloat*)malloc(4*sizeof(GLfloat));
    GLfloat colorB[4];//=(GLfloat*)malloc(4*sizeof(GLfloat));
    GLfloat midColor[4];//=(GLfloat*)malloc(4*sizeof(GLfloat));
    if(_currentTime<_transferTime){
        switch (_transferMode) {
            case MODE_COLOR:
                if(_currentTime<_transferTime/2.0){
                    RhombusSlide *nextSlide = (RhombusSlide*) [slides objectAtIndex:currentSlide+1];
                    colorMix(slide.colorA, nextSlide.colorA, _currentTime/_transferTime, colorA);
                    colorMix(slide.colorB, nextSlide.colorB, _currentTime/_transferTime, colorB);
                }else{
                    if(!_slideReplaced){
                        currentSlide++;
                        [self prepareNextSlide];
                        _slideReplaced=true;
                    }
                    RhombusSlide *previousSlide = (RhombusSlide*) [slides objectAtIndex:currentSlide-1];
                    colorMix( previousSlide.colorA, slide.colorA, _currentTime/_transferTime, colorA);
                    colorMix( previousSlide.colorB, slide.colorB,_currentTime/_transferTime, colorB);
                    
                    
                }
                break;
            case MODE_ALL:
                if(_currentTime<_transferTime/2.0){
                    RhombusSlide *nextSlide = (RhombusSlide*) [slides objectAtIndex:currentSlide+1];
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
                    RhombusSlide *previousSlide = (RhombusSlide*) [slides objectAtIndex:currentSlide-1];
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
        [array draw:vMatrix :colorA :colorB :0.0:1.0];
        
    }else{
        _doTransfer=false;
        [array draw:vMatrix :slide.colorA :slide.colorB :0.0:1.0];
        [self resetTimeCounter];
    }
}

-(void) onFadeOut{
    _fadeFactor=(1.0-_currentTime/_fadeOutTime);
    [array draw: vMatrix:slide.colorA: slide.colorB: 0.0: _fadeFactor];
}

-(void) releaseOpenglResources{
    [array releaseOpenglResources];
}

@end
