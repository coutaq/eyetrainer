//
//  SquareSlide.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "SquareSlide.h"

@implementation SquareSlide

@synthesize time;
@synthesize accelerationFactor;
@synthesize colorA;
@synthesize colorB;
@synthesize countX;
@synthesize countY;

-(id) init:(long) theTime: (float) theAccelerationFactor:(float*) theColorA:(float*) theColorB:(int) theCountX:(int) theCountY{
    self=[super init];
    if(self!=nil){
        self.time=theTime;
        self.accelerationFactor=theAccelerationFactor;
        self.colorA=theColorA;
        self.colorB=theColorB;
        self.countX=theCountX;
        self.countY=theCountY;
    }
    return self;
}

-(BOOL) isEqualTo:(SquareSlide *)slide{
    return (countX==slide.countX && countY==slide.countY);
}

@end
