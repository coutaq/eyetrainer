//
//  RhombusArray.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/6/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//


#import "Utils.h"
#import "ObjectFactory.h"

@interface RhombusArray : NSObject{
    GLuint _program;
    GLuint _positionHandle;
    GLuint _textureHandle;
    GLuint _textureUniformHandle;
    GLuint _MVPMatrixUniformHandle;
    GLuint _fadeUniformHandle;
    GLuint _colorAHandle;
    GLuint _colorBHandle;
    
    //Main containers
    GLfloat *_geometryCoords;
    GLfloat *_textureCoords;
    
    //Container sizes
    int geometryCoordsSize;
    int textureCoordsSize;
    
    //Suppport containers
    NSMutableArray *_orientationData;
    
    //Strides
    int _vertexStride;
    
    //Texture
    GLuint _texture;
    //Time
    
    //TextureOffset
    float currentOffset;
    float tiles;
    
}
-(id) init;
-(void) setRhombusesParameters: (float) sizeX: (float) sizeY: (float) startPointX: (float) startPointY: (int) countX: (int) countY: (float) tilesFactor;
- (void) draw:(mat4) viewMatrix:(float*) colorA: (float*) colorB :(float) offset:(float) fade;
-(void) reset;
-(void) releaseOpenglResources;

@end
