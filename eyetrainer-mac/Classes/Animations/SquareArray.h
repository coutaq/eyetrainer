//
//  SquareArray.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface SquareArray : NSObject{
    
    GLuint _program;
    GLuint _positionHandle;
    GLuint _matrixUniformHandle;
    GLuint _colorAHandle;
    GLuint _colorBHandle;
    GLuint _squareDimensionsHandle;
    GLuint _alignPointHandle;
    GLuint _colorMultiplierHandle;
    GLfloat *_geometryCoords;
    
    float squareSizeX;
    float squareSizeY;
    float alignPointX;
    float alignPointY;
}

-(id) init;
-(void)setSquaresProperties:(float) sizeX:(float) sizeY:(float) startPointX:(float) startPointY:(int) countX:(int) countY;
- (void) draw:(mat4) viewMatrix:(GLfloat*) colorA:(GLfloat*) colorB:(GLfloat) colorMultiplier;
-(void) releaseOpenglResources;

@end
