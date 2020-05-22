//
//  Wave.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/10/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

//
//  SquareArray.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Wave.h"
#import "GlobalInfo.h"
#import "Utils.h"

@interface Wave()

-(void) onFadeIn;
-(void) onSlideShow;
-(void) onFadeOut;

@end

@implementation Wave

//Shaders code
static const char *vsRhombusCode = "\
attribute vec4 a_Position;\
varying vec2 v_Pos;\
uniform mat4 u_Matrix;\
void main() {\
gl_Position = a_Position * u_Matrix;\
v_Pos=vec2(a_Position.x,a_Position.y);}";

static const char *fsRhombusCode = "\
#define PI 3.14159265\n\
const vec4 col1=vec4(0.15,0.1,0.6,1.0);\
const vec4 col2=vec4(0.5,0.5,0.8,1.0);\
varying vec2 v_Pos;\
uniform vec2 u_resolution;\
uniform float u_Fade;\
uniform float time;\
float myFunct(float x){\
float t=abs((mod(x,PI)-(PI/2.0))/PI*2.0);\
return t;\
}\
void main(void){\
float y = v_Pos.y*2.2+1.2;\
float x = (v_Pos.x*3.0);\
float a = (sin(y*2.0+time*4.5)+1.0);\
float mx=x+1.34*(a+time*4.5);\
float z = mod(time, 6.28);\
float my=y+0.4*cos(-0.6*x)+0.3*cos(z);\
float c = myFunct(my + 2.5*sin(mx)/PI);\
gl_FragColor = mix(col2,col1,c)*u_Fade;}";

//Matrix
static mat4 vMatrix;

//Constant bindings
static const GLfloat depthPosition = -0.0f;
static const int geometryCoordsSize=18;

//Time
static const long maxTime=60000;

-(void) prepare{
    _fadeInTime=3000;
    _fadeOutTime=3000;
    
    matrixOrtho(vMatrix);
    
    float height=[GlobalInfo SizeFactor];
    float halfHeight=height/2.;
    float halfWidth=[GlobalInfo ScreenWidth]/ [GlobalInfo ScreenHeight]*halfHeight;
    
    GLfloat coords[]={
        -halfWidth, -halfHeight, -depthPosition,
        halfWidth, -halfHeight, -depthPosition,
        -halfWidth, halfHeight, -depthPosition,
        
        halfWidth, -halfHeight, -depthPosition,
        halfWidth, halfHeight, -depthPosition,
        -halfWidth, halfHeight, -depthPosition
    };
    
    int n=sizeof(coords)/sizeof(coords[0]);
    _geometryCoords=malloc(sizeof(GLfloat)*n);
    memcpy(_geometryCoords, coords, sizeof(coords));
    
    GLuint vsh, fsh;
    vsh = newShader(GL_VERTEX_SHADER, &vsRhombusCode);
    fsh = newShader(GL_FRAGMENT_SHADER, &fsRhombusCode);
    
    _program=newProgram(vsh, fsh);
    
    
    glDeleteShader(vsh);
    glDeleteShader(fsh);
    
    glUseProgram(_program);
    
    _positionHandle=glGetAttribLocation(_program, "a_Position");
    _matrixUniformHandle=glGetUniformLocation(_program, "u_Matrix");
    _screenDimensionsHandle=glGetUniformLocation(_program, "u_resolution");
    _timeHandle=glGetUniformLocation(_program,"time");
    _fadeUniformHandle=glGetUniformLocation(_program, "u_Fade");
    
    glEnableVertexAttribArray(_positionHandle);
    
    [self resetTimeCounter];
    
    [self startInternalTimer];
    
    _internalSavedTime=0;
}

- (void) draw{
    
    [super setDrawParams];
    
    
    
    glUniformMatrix4fv(_matrixUniformHandle, 1, GL_FALSE, vMatrix);
    
    glUniform2f(_screenDimensionsHandle, [GlobalInfo ScreenHeight], [GlobalInfo ScreenWidth]);
    _currentInternalTime=[_internalTime timeIntervalSinceNow]+_internalSavedTime;
    
    glUniform1f(_timeHandle, _currentInternalTime);
    
    glUniform1f(_fadeUniformHandle, _fadeFactor);
    
    glVertexAttribPointer(_positionHandle, 3, GL_FLOAT, GL_FALSE, 12 ,_geometryCoords);
    
    glDrawArrays(GL_TRIANGLES, 0, (int)(geometryCoordsSize/3));
}

- (void) reset{
    
}

- (void) dealloc{
    [super dealloc];
    [_internalTime release];
    free(_geometryCoords);
}

- (void) onFadeIn{
    _fadeFactor=_currentTime/_fadeInTime;
}

- (void) onSlideShow{
    if(_currentTime>maxTime){
        _slidesFinished=true;
        [self resetTimeCounter];
    }
    
}

- (void) onFadeOut{
    _fadeFactor=(1.0-_currentTime/_fadeOutTime);
}

- (void) pause{
    [super pause];
    _internalSavedTime=_currentInternalTime;
    [_internalTime release];
    _internalTime=nil;
    
}

- (void) resume{
    [super resume];
    [self startInternalTimer];
}

-(void) startInternalTimer{
    if(_internalTime!=nil)
    {
        [_internalTime release];
        _internalTime=nil;
    }
    _internalTime =[[NSDate date] retain];
}

-(void) releaseOpenglResources{
    glDisableVertexAttribArray(_positionHandle);
    glDeleteProgram(_program);
}

@end
