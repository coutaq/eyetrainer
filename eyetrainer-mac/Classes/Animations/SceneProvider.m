//
//  SceneProvider.m
//  OSXGLEssentials
//
//  Created by Denys Nikolayenko on 1/29/13.
//
//

#import "SceneProvider.h"
#import "Corridor.h"
#import "Squares.h"
#import "Wave.h"
#import "Rhombuses.h"
//#import "Constants.h"

@implementation SceneProvider

+(NSArray*) getScenes
{
#if APP_IN_DEBUG == 1
        return [[[NSArray alloc] initWithObjects:
                  [[[Corridor alloc]init] autorelease],
                  nil] autorelease];
#else
        return [[[NSArray alloc] initWithObjects:
                  [[[Corridor alloc]init] autorelease],
                  [[[Squares alloc]init] autorelease],
                  [[[Wave alloc]init] autorelease],
                  [[[Rhombuses alloc]init] autorelease],
                  [[[Corridor alloc]init] autorelease],
                  nil] autorelease];
#endif
}

@end
