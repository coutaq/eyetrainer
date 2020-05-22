//
//  TimePoint.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/1/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "TimePoint.h"



@implementation TimePoint

@synthesize time_ms;

@synthesize value;

-(id) init:(long) time: (float) val{
    self = [super init];
    if (self !=nil) {
        self.value=val;
        self.time_ms=time;        
    }
    return self;
}

@end
