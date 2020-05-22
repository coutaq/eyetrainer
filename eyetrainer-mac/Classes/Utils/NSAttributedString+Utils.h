//
//  NSAttributedString+Utils.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/22/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Utils)

+(NSAttributedString*) stringWithString:(NSString*) string andFont:(NSFont*) font ofColor:(NSColor*) color;
+(NSAttributedString*) centeredStringWithString:(NSString *)string andFont:(NSFont *)font ofColor:(NSColor *)color;


@end
