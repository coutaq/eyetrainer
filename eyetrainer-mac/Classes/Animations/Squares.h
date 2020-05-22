//
//  Squares.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/9/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Drawable.h"
#import "SquareArray.h"
#import "Utils.h"
#import "SquareSlide.h"

@interface Squares : Drawable{
    
    NSArray *slides;
    NSUInteger currentSlide;
    SquareArray *array;
    
    float distance;
    float currentSpeed;
    float colorMultiplier;
    float screenWidth;
    float screenHeight;
    
    SquareSlide *slide;
    BOOL _doTransfer;
    BOOL _slideReplaced;
    int _transferMode;
    float _transferTime;
    
}

-(void) draw;
-(void) reset;
-(void) dealloc;

@end
