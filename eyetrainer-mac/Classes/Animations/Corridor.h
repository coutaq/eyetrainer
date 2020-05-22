//
//  Corridor.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/1/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"
@interface Corridor : Drawable{
    
    GLuint _program;
    GLuint _positionHandle;
    GLuint _waveLengthUniformHandle;
    GLuint _phaseUniformHandle;
    GLuint _fadeUniformHandle;
    GLuint _MVPMatrixUniformHandle;
    
    double anchorOffset;
    NSUInteger currentSlide;
    double currentOffset;
        
    NSArray *slides;
}

-(void) draw;
-(void) reset;
@end
