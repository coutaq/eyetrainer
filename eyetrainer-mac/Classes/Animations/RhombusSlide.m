//
//  RhombusSlide.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "RhombusSlide.h"

@implementation RhombusSlide

@synthesize time = _time;
@synthesize colorA = _colorA;
@synthesize colorB = _colorB;
@synthesize tiles = _tiles;
@synthesize speed = _speed;
@synthesize countX = _countX;
@synthesize countY = _countY;

-(id) init:(long)theTime :(float*) theColorA:(float*) theColorB :(float)theTiles :(int)theSpeed :(int)theCountX :(int)theCountY{
    self=[super init];
    if(self!=nil){
        self.time=theTime;
        self.colorA=theColorA;
        self.colorB=theColorB;
        self.tiles=theTiles;
        self.speed=theSpeed;
        self.countX=theCountX;
        self.countY=theCountY;
    }
    return self;
}

-(BOOL) isEqualTo:(RhombusSlide *)slide{
    return (self.tiles==slide.tiles && self.countX==slide.countX && self.countY==slide.countY);
}

@end
