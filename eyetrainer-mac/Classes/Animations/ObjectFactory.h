//
//  ObjectFactory.h
//  CubeExample
//
//  Created by Denys Nikolayenko on 8/6/12.
//  Copyright (c) 2012 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectFactory : NSObject{
    
    GLfloat *anchorCoords;
    int size;
    
}

-(id) init:(GLfloat*) anchor: (int) count;

-(NSArray*) make:(float) displacementX:(float) displacementY;

@end
