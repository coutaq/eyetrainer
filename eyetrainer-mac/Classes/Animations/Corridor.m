
//  Corridor.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/1/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Corridor.h"
#import "Utils.h"
#import "TimePoint.h"
#import "GlobalInfo.h"
#import <math.h>
//#import "Constants.h"

@interface Corridor()

-(void) onFadeIn;
-(void) onSlideShow;
-(void) onFadeOut;
@end



@implementation Corridor 

//Parameters
static const GLfloat physicalDepth = 8.0f;
static const float speedScale=1.0f;
static const float waveLength=70.0f; //As bigger=as wave shorter

//Shaders code
static const char *vsCode = "\
uniform mat4 u_Mat;\
attribute vec4 a_Pos;\
varying vec2 v_Pos;\
void main() {\
    gl_Position = a_Pos * u_Mat;\
    v_Pos = vec2(a_Pos.x,a_Pos.y);}";

static const char *fsCode = "\
#define TWOPI 6.28318531\n\
uniform float u_WaveLength;\
uniform float u_Fade;\
uniform float u_Phase;\
varying vec2 v_Pos;\
void main() {\
    float x;\
    if(v_Pos.x+v_Pos.y<0.0 ){\
    x=(v_Pos.x<v_Pos.y)? v_Pos.x*u_WaveLength : v_Pos.y*u_WaveLength;\
    }else{\
    x=(v_Pos.x>v_Pos.y)? -v_Pos.x*u_WaveLength : -v_Pos.y*u_WaveLength;}\
    float m=(0.5*sin(x+u_Phase*TWOPI)+0.5)*u_Fade;\
    gl_FragColor = vec4(m,m,m,0.0);\
    }";


//Main containers
static const int geometryCoordinateSize=36;
static GLfloat _geometryCoords[]={
    -0.5f, -0.5, 0.0, 
    0.0, 0.0, -physicalDepth,
    -0.5, 0.5f, 0.0f,
    
    -0.5f, 0.5f, 0.0f, 
    0.0f, 0.0f, -physicalDepth, 
    0.5f, 0.5f, 0.0f,
    
    0.5f, 0.5f, 0.0f, 
    0.0f, 0.0f, -physicalDepth, 
    0.5f, -0.5f, 0.0f,
    
    0.5f, -0.5f, 0.0f, 
    0.0f, 0.0f, -physicalDepth, 
    -0.5f, -0.5f, 0.0f };


//Strides
static int _vertexStride;

//Matrix
static mat4 vMatrix;

- (void) prepare{
    
    _fadeInTime=2500;
    _fadeOutTime=1000;
    
    float ratio = [GlobalInfo ScreenHeight]/[GlobalInfo ScreenWidth];
    
    matrixPerspective(ratio*0.5, -ratio*0.5, 0.5, -0.5, 2.8, 50., vMatrix);
    
    _vertexStride=sizeof(GLfloat)*3;
#if APP_IN_DEBUG == 1
    
    slides=[[NSArray alloc] initWithObjects:
            [[[TimePoint alloc]init:1500 : 0.4]autorelease] ,nil];
#else
    slides=[[NSArray alloc] initWithObjects:
            [[[TimePoint alloc]init:1500 : 0.4]autorelease],
            [[[TimePoint alloc]init:1500 : 0.8]autorelease],
            [[[TimePoint alloc]init:1500 : 1.2]autorelease],
            [[[TimePoint alloc]init:6000 : 6.0]autorelease],
            [[[TimePoint alloc]init:1500 : 1.2]autorelease],
            [[[TimePoint alloc]init:1500 : 0.8]autorelease],
            [[[TimePoint alloc]init:1500 : 0.4]autorelease],
            [[[TimePoint alloc]init:1000 : 0.0]autorelease],
            [[[TimePoint alloc]init:1500 : -0.4]autorelease],
            [[[TimePoint alloc]init:1500 : -0.8]autorelease],
            [[[TimePoint alloc]init:1500 : -1.2]autorelease],
            [[[TimePoint alloc]init:6000 : -6.0]autorelease],
            [[[TimePoint alloc]init:1500 : -1.2]autorelease],
            [[[TimePoint alloc]init:1500 : -0.8]autorelease],
            [[[TimePoint alloc]init:1500 : -0.4]autorelease],
            [[[TimePoint alloc]init:1000 : 0.0]autorelease],
            [[[TimePoint alloc]init:1000 : 0.2]autorelease],
            [[[TimePoint alloc]init:1000 : 0.4]autorelease],
            [[[TimePoint alloc]init:1000 : 0.6]autorelease],
            [[[TimePoint alloc]init:1000 : 0.8]autorelease],
            [[[TimePoint alloc]init:8000 : 10.0]autorelease],
            [[[TimePoint alloc]init:1000 : 0.8]autorelease],
            [[[TimePoint alloc]init:1000 : 0.6]autorelease],
            [[[TimePoint alloc]init:1000 : 0.4]autorelease],
            [[[TimePoint alloc]init:1000 : 0.2]autorelease],
            [[[TimePoint alloc]init:1000 : 0.0]autorelease],
            [[[TimePoint alloc]init:1000 : -0.2]autorelease],
            [[[TimePoint alloc]init:1000 : -0.4]autorelease],
            [[[TimePoint alloc]init:1000 : -0.6]autorelease],
            [[[TimePoint alloc]init:1000 : -0.8]autorelease],
            [[[TimePoint alloc]init:8000 : -10.0]autorelease],
            [[[TimePoint alloc]init:1000 : -0.8]autorelease],
            [[[TimePoint alloc]init:1000 : -0.6]autorelease],
            [[[TimePoint alloc]init:1000 : -0.4]autorelease],
            [[[TimePoint alloc]init:1000 : -0.2]autorelease],
            [[[TimePoint alloc]init: 500 : 0.0]autorelease],nil];
#endif
    
    currentOffset=0;
    currentSlide=0;
    
    anchorOffset=0;
    
    GLuint vsh, fsh;
    vsh = newShader(GL_VERTEX_SHADER, &vsCode);
    fsh = newShader(GL_FRAGMENT_SHADER, &fsCode);
    
    _program=newProgram(vsh, fsh);
    
    glDeleteShader(vsh);
    glDeleteShader(fsh);
    
    _MVPMatrixUniformHandle=glGetUniformLocation(_program, "u_Mat");
    _waveLengthUniformHandle=glGetUniformLocation(_program, "u_WaveLength");
    _phaseUniformHandle=glGetUniformLocation(_program,"u_Phase");
    _fadeUniformHandle=glGetUniformLocation(_program, "u_Fade");
    
    _positionHandle=glGetAttribLocation(_program, "a_Pos");
    
    glEnableVertexAttribArray(_positionHandle);
    
    [self resetTimeCounter];
}

- (void) draw{
    [super setDrawParams];
    glUseProgram(_program);
    
    glUniformMatrix4fv(_MVPMatrixUniformHandle, 1, GL_FALSE, vMatrix);
    glUniform1f(_waveLengthUniformHandle, waveLength);
    glUniform1f(_phaseUniformHandle, currentOffset);
    glUniform1f(_fadeUniformHandle, _fadeFactor);
    
    glVertexAttribPointer(_positionHandle, 3, GL_FLOAT, GL_FALSE, _vertexStride, _geometryCoords);
  
    glDrawArrays(GL_TRIANGLES, 0, 12);
    
    
}

- (void) reset{
    
}

- (void) dealloc{
    [slides release];
    [super dealloc];
}

- (void) setOffset:(float) value{
    currentOffset=anchorOffset+value;
}


- (void) onFadeIn{
    _fadeFactor=_currentTime/_fadeInTime;
}
- (void) onSlideShow{
    TimePoint* state=[slides objectAtIndex:currentSlide];
    if(_currentTime>state.time_ms){
        if(currentSlide<[slides count]-1){
            currentSlide++;
            state=[slides objectAtIndex:currentSlide];
            [self resetTimeCounter];
            anchorOffset=currentOffset;
        }else{
            _slidesFinished=true;
            [self resetTimeCounter];
            return;
        }
    }
    
 
    [self setOffset:(state.value*(_currentTime/state.time_ms)/speedScale)];
}
-(void) onFadeOut{
    _fadeFactor=(1.0-_currentTime/_fadeOutTime);
}

-(void) releaseOpenglResources{
    glDisableVertexAttribArray(_positionHandle);
    glDeleteProgram(_program);
}

@end
