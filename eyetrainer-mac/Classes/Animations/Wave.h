//
//  Wave.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/10/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Drawable.h"

@interface Wave : Drawable{
    //Program and handlers 
    GLuint _program;
    GLuint _positionHandle;
    GLuint _matrixUniformHandle;
    GLuint _screenDimensionsHandle;
    GLuint _timeHandle;
    GLuint _fadeUniformHandle;
    NSDate *_internalTime;
    //Main containers
    GLfloat *_geometryCoords;
    float _currentInternalTime;
    float _internalSavedTime;
}


-(void) draw;
-(void) reset;
-(void) dealloc;

@end
