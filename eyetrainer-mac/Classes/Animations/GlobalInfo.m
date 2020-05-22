//
//  GlobalInfo.m
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import "GlobalInfo.h"

@implementation GlobalInfo

static float screenWidth;
static float screenHeight;
static float sizeFactor;

+(void) initialize:(float)theWidth :(float)theHeight:(float) theSize{
    static BOOL initialized=false;
    if(!initialized)
    {
        screenWidth=theWidth;
        screenHeight=theHeight;
        sizeFactor=theSize;
        initialized=true;
    }
    
}

+(float) ScreenWidth{
    return  screenWidth;
}

+(float) ScreenHeight{
    return screenHeight;
}

+(float) SizeFactor{
    return sizeFactor;
}

@end
