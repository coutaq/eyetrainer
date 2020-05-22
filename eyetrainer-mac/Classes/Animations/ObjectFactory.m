//
//  ObjectFactory.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/6/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "ObjectFactory.h"

@implementation ObjectFactory

-(id) init:(GLfloat*) anchor: (int) count{
    self=[super init];
    if(self!=nil){
        anchorCoords=anchor;    
        size = count;
    }
    return self;
}

-(NSArray*) make:(float)displacementX :(float)displacementY{
   
    NSMutableArray *_temp = [[NSMutableArray alloc] init];
    for(int i=0; i<size; i+=3){
        float f = anchorCoords[i]+displacementX;
        [_temp addObject: [NSNumber numberWithFloat: f ]];
        f=anchorCoords[i+1] + displacementY;
        [_temp addObject:[NSNumber numberWithFloat:f]];
        f=anchorCoords[i+2];
        [_temp addObject:[NSNumber numberWithFloat:f]];
    }
    NSArray *result=[[NSArray alloc] initWithArray: _temp];
    [_temp release];
    return [result autorelease];
}

-(void)dealloc{
    [super dealloc];
}

@end
