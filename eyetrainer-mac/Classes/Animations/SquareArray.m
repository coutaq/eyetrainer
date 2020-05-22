//
//  SquareArray.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "SquareArray.h"

#define PI 3.141592653589f

@implementation SquareArray

//Shaders code
static const char *vsRhombusCode = "\
attribute vec4 a_Position;\
uniform mat4 u_Matrix;\
uniform vec2 u_AlignPoint;\
varying vec2 v_Point;\
void main() {\
gl_Position = a_Position * u_Matrix;\
v_Point = vec2(a_Position.x-u_AlignPoint.x,a_Position.y-u_AlignPoint.y);}";

static const char *fsRhombusCode = "\
varying vec2 v_Point;\
uniform vec4 u_ColorA;\
uniform vec4 u_ColorB;\
uniform vec2 u_SquareDims;\
uniform float u_ColorMultiplier;\
void main() {\
float ratio=0.5+sin(v_Point.x/u_SquareDims.x)*sin(v_Point.y/u_SquareDims.y)*0.5*u_ColorMultiplier;\
gl_FragColor = mix(u_ColorA, u_ColorB, ratio);\
}";



//Constant bindings
static const GLfloat depthPosition = -0.0f;
static const int geometryCoordsSize=18;




-(id) init{
    self=[super init];
    if(self!=nil)
    {

        GLuint vsh, fsh;
        vsh = newShader(GL_VERTEX_SHADER, &vsRhombusCode);
        fsh = newShader(GL_FRAGMENT_SHADER, &fsRhombusCode);
        _program=newProgram(vsh, fsh);
        glDeleteShader(vsh);
        glDeleteShader(fsh);
        
        _positionHandle=glGetAttribLocation(_program, "a_Position");
        _matrixUniformHandle=glGetUniformLocation(_program, "u_Matrix"); 
        _colorAHandle=glGetUniformLocation(_program, "u_ColorA");
        _colorBHandle=glGetUniformLocation(_program, "u_ColorB");
        _squareDimensionsHandle=glGetUniformLocation(_program, "u_SquareDims");
        _alignPointHandle=glGetUniformLocation(_program, "u_AlignPoint");
        _colorMultiplierHandle=glGetUniformLocation(_program, "u_ColorMultiplier");
        
        glEnableVertexAttribArray(_positionHandle);
        
    }
    return self;
}

-(void) setSquaresProperties:(float) sizeX:(float) sizeY:(float) startPointX:(float) startPointY:(int) countX:(int) countY{
    squareSizeX=sizeX/PI;
    squareSizeY=sizeY/PI;
    
    alignPointX=startPointX;
    alignPointY=startPointY;
    
    
    GLfloat coords[]={
        startPointX, startPointY, depthPosition,
        startPointX, startPointY - sizeY*countY, depthPosition,
        startPointX - sizeX*countX, startPointY, depthPosition,
        
        startPointX - sizeX*countX, startPointY, depthPosition,
        startPointX, startPointY - sizeY*countY, depthPosition,
        startPointX - sizeX*countX, startPointY - sizeY*countY, depthPosition
    };
    if(_geometryCoords!=nil){
        free(_geometryCoords);
        _geometryCoords=nil;
    }
    int n=sizeof(coords)/sizeof(coords[0]);
    _geometryCoords=malloc(sizeof(GLfloat)*n);
    memcpy(_geometryCoords, coords, sizeof(coords));
    
}

- (void) draw:(mat4) viewMatrix:(GLfloat*) colorA:(GLfloat*) colorB:(GLfloat) colorMultiplier {
    glUseProgram(_program);
    

    glUniformMatrix4fv(_matrixUniformHandle, 1, GL_FALSE, viewMatrix);
    
    glUniform4fv(_colorAHandle, 1, colorA);
    glUniform4fv(_colorBHandle, 1, colorB);
    
    glUniform2f(_squareDimensionsHandle, squareSizeX, squareSizeY);
    glUniform2f(_alignPointHandle, alignPointX, alignPointY);
    
    glUniform1f(_colorMultiplierHandle, colorMultiplier);
    
    glVertexAttribPointer(_positionHandle, 3, GL_FLOAT, GL_FALSE, 12 ,_geometryCoords);
    
    glDrawArrays(GL_TRIANGLES, 0, (int)(geometryCoordsSize/3));
}

- (void) reset{
    
}

- (void) dealloc{
    free(_geometryCoords);
    [super dealloc];
}

- (void) releaseOpenglResources{
    
    glDisableVertexAttribArray(_positionHandle);
    glDeleteProgram(_program);
}

@end
