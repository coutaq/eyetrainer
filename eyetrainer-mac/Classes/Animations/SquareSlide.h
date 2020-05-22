//
//  SquareSlide.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareSlide : NSObject

@property (readwrite) long time;
@property (readwrite) float accelerationFactor;
@property (readwrite) float* colorA;
@property (readwrite) float* colorB;
@property (readwrite) int countX;
@property (readwrite) int countY;

-(id) init:(long) time: (float) accelerationFactor:(float*) colorA:(float*) colorB:(int) countX:(int) countY;
-(BOOL) isEqualTo:(SquareSlide*)slide;
@end
