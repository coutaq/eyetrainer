//
//  TimePoint.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/1/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimePoint : NSObject 
    @property(readwrite)long time_ms;
    @property(readwrite) float value;

-(id) init:(long) time: (float) value;

@end
