//
//  RhombusSlide.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RhombusSlide : NSObject{
    
}

@property (readwrite, assign) long time;
@property (readwrite) float tiles;
@property (readwrite) float* colorA;
@property (readwrite) float* colorB;
@property (readwrite) int speed;
@property (readwrite) int countX;
@property (readwrite) int countY;

-(id) init:(long)theTime :(float*) theColorA:(float*) theColorB :(float)theTiles :(int)theSpeed :(int)theCountX :(int)theCountY;
-(BOOL) isEqualTo:(RhombusSlide*)slide;
@end
