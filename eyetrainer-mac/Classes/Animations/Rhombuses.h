//
//  Rhombuses.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "Drawable.h"
#import "RhombusArray.h"
#import "RhombusSlide.h"

@interface Rhombuses : Drawable{
    NSArray *slides;
    NSUInteger currentSlide;
    RhombusArray *array;
    RhombusSlide *slide;
    BOOL _doTransfer;
    BOOL _slideReplaced;
    int _transferMode;
    float _transferTime;
}
-(void) draw;
-(void) reset;

@end
