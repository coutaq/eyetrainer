//
//  RhombusArray.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/6/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "RhombusArray.h"
#import "Utils.h"

@implementation RhombusArray 

#define TYPE_EXPLOSION true
#define TYPE_IMPLOSION false

#define TEXTURE_NAME @"rhombus_pattern.png"

//Shaders code
static const char *vsRhombusCode = "\
uniform mat4 u_Mat;\
attribute vec4 a_Pos;\
attribute vec2 a_Tex;\
varying vec2 v_Tex;\
void main() {\
gl_Position = a_Pos * u_Mat;\
v_Tex = a_Tex;}";

static const char *fsRhombusCode = "\
uniform sampler2D u_TexData;\
uniform float u_Fade;\
uniform vec4 u_ColorA;\
uniform vec4 u_ColorB;\
varying vec2 v_Tex;\
void main() {\
gl_FragColor = mix(u_ColorA,u_ColorB,texture2D(u_TexData, v_Tex).x)*u_Fade;\
}";

//Constant bindings
static const GLfloat depthPosition = -1.0f;
static int textureAnchorSize=24;
static GLfloat textureAnchor[] = {
    
	1.0, 0.0, 1.0, 0.5, 0.0, 0.0,
    
	0.0, 0.0, 0.0, 0.5, 1.0, 0.0,
    
	1.0, 0.0, 1.0, 0.5, 0.0, 0.0,
    
	0.0, 0.0, 0.0, 0.5, 1.0, 0.0 };

//Program and handlers 


- (id) init{
    self=[super init];
    if(self!=nil){
        
        
        
        _vertexStride=sizeof(GLfloat)*3;
        
        
        GLuint vsh, fsh;
        vsh = newShader(GL_VERTEX_SHADER, &vsRhombusCode);
        fsh = newShader(GL_FRAGMENT_SHADER, &fsRhombusCode);
        
        _program=newProgram(vsh, fsh);
        
                
        glDeleteShader(vsh);
        glDeleteShader(fsh);
        
        _MVPMatrixUniformHandle=glGetUniformLocation(_program, "u_Mat"); 
        _textureUniformHandle=glGetUniformLocation(_program, "u_TexData");
        _fadeUniformHandle=glGetUniformLocation(_program, "u_Fade");
        _colorAHandle=glGetUniformLocation(_program, "u_ColorA");
        _colorBHandle=glGetUniformLocation(_program, "u_ColorB");
        
        _positionHandle=glGetAttribLocation(_program, "a_Pos");
        _textureHandle=glGetAttribLocation(_program, "a_Tex");
        
        glEnableVertexAttribArray(_positionHandle);
        glEnableVertexAttribArray(_textureHandle);
        
        
        
        _texture = newTexture(TEXTURE_NAME);
        
    };
    return self;
}

-(void) setRhombusesParameters: (float) sizeX: (float) sizeY: (float) startPointX: (float) startPointY: (int) countX: (int) countY: (float) tilesFactor{
    tiles = tilesFactor;
    
    GLfloat anchorCoords[]={
        startPointX, startPointY - sizeY, depthPosition,
        startPointX - sizeX / 2.0, startPointY - sizeY / 2.0, depthPosition, startPointX,
        startPointY, depthPosition,
        
        startPointX - sizeX, startPointY - sizeY, depthPosition, startPointX - sizeX / 2.0,
        startPointY - sizeY / 2.0, depthPosition, startPointX, startPointY - sizeY,
        depthPosition,
        
        startPointX - sizeX, startPointY, depthPosition, startPointX - sizeX / 2.0,
        startPointY - sizeY / 2.0, depthPosition, startPointX - sizeX, startPointY - sizeY,
        depthPosition,
        
        startPointX, startPointY, depthPosition, startPointX - sizeX / 2.0,
        startPointY - sizeY / 2.0, depthPosition, startPointX - sizeX, startPointY,
        depthPosition
        
    };
    
    ObjectFactory *factory;
    
    factory = [[ObjectFactory alloc] init: anchorCoords: 36];
    
    if(_orientationData!=nil){
        [_orientationData release];
        _orientationData=nil;
    }
    _orientationData =[[NSMutableArray alloc] init];
    
    NSMutableArray *vertices = [[NSMutableArray alloc] init];
    
    float anchorX=0;
    float anchorY=0;
    BOOL isOppositeRhombus=true;
    BOOL isEvenRow=false;
    
    for(int i=0; i<countY; i++){
        for(int j=0; j<countX; j++){
            if(isOppositeRhombus){
                [_orientationData addObject:[NSNumber numberWithBool:TYPE_EXPLOSION]];
            }else{
                [_orientationData addObject: [NSNumber numberWithBool:TYPE_IMPLOSION]];
            }
            NSArray *array=[[factory make:anchorX :anchorY] retain];
            [vertices addObjectsFromArray: array];
            [array release];
            anchorX-=sizeX;
            isOppositeRhombus=!isOppositeRhombus;
            
        }
        anchorX=0;
        anchorY -=sizeY;
        isEvenRow = !isEvenRow;
        isOppositeRhombus = !isEvenRow;
    }
    
    geometryCoordsSize=[vertices count];
    
    if(_geometryCoords !=nil){
        free(_geometryCoords);
    }
    _geometryCoords=(GLfloat*)malloc(geometryCoordsSize*sizeof(GLfloat));
    
    for(int i=0; i<geometryCoordsSize;i++)
    {
        GLfloat a =[[vertices objectAtIndex:i] floatValue];
        _geometryCoords[i]=a;
    }
    
    
    
    [vertices release];
    [factory release];
    
    textureCoordsSize=([_orientationData count]*textureAnchorSize);
    
    if(_textureCoords!=nil){
        free(_textureCoords);    
    }
    _textureCoords=(GLfloat*)malloc(textureCoordsSize*sizeof(GLfloat));
    
    [self createTextureCoords:0.0];
    
    
}

- (void) draw:(mat4) viewMatrix:(float*) colorA: (float*) colorB :(float) offset:(float) fade{
    glUseProgram(_program);
    
    [self createTextureCoords:offset];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glUniform1i(_textureUniformHandle, 0);
    
    glUniform1f(_fadeUniformHandle, fade);
    
    glUniform4fv(_colorAHandle, 1, colorA);
    glUniform4fv(_colorBHandle, 1, colorB);
    
    glUniformMatrix4fv(_MVPMatrixUniformHandle, 1, GL_FALSE, viewMatrix);
    
    glVertexAttribPointer(_positionHandle, 3, GL_FLOAT, GL_FALSE, 12 ,_geometryCoords);
    glVertexAttribPointer(_textureHandle, 2, GL_FLOAT, GL_FALSE, 8, _textureCoords);
    
    glDrawArrays(GL_TRIANGLES, 0, (int)(geometryCoordsSize/3));
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void) reset{
    
}

- (void) dealloc{
    [_orientationData release];
    free(_geometryCoords);
    free(_textureCoords);
    [super dealloc];
}

- (void) createTextureCoords:(float) offset{
    int m=[_orientationData count];
    for(int i=0; i<m; i++){
        int k=i*textureAnchorSize;
        for(int j=0; j<textureAnchorSize;j++){
            _textureCoords[j+k]=textureAnchor[j]*tiles;
        }
        BOOL a=[[_orientationData objectAtIndex:i] boolValue];
        if(a==TYPE_EXPLOSION){
            for(int j=1; j<textureAnchorSize; j+=2){
                _textureCoords[j+k]+=offset;
            }
        }else{
            for(int j=1; j<textureAnchorSize; j+=2){
                _textureCoords[j+k]-=offset;
            }
        }
    }
}

-(void) releaseOpenglResources{
    glDisableVertexAttribArray(_positionHandle);
    glDisableVertexAttribArray(_textureHandle);
    glDeleteTextures(1, &_texture);
    glDeleteProgram(_program);
}



@end
