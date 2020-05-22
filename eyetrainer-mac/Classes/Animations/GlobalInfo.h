//
//  GlobalInfo.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/8/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalInfo : NSObject

+(void) initialize:(float) theWidth:(float) theHeight:(float) theSize;
+(float) ScreenWidth;
+(float) ScreenHeight;
+(float) SizeFactor;

@end
