//
//  NSAttributedString+Colored.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/22/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "NSAttributedString+Utils.h"

@implementation NSAttributedString (Utils)

+(NSAttributedString*) centeredStringWithString:(NSString *)string andFont:(NSFont *)font ofColor:(NSColor *)color{
    
    NSMutableParagraphStyle *centredStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [centredStyle setAlignment:NSCenterTextAlignment];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    centredStyle, NSParagraphStyleAttributeName,
                                    font, NSFontAttributeName,
                                    color, NSForegroundColorAttributeName,
                                    nil];
    
    return [[NSAttributedString alloc]initWithString:string attributes:textAttributes] ;
}

+(NSAttributedString *)stringWithString:(NSString *)string andFont:(NSFont *)font ofColor:(NSColor *)color{
    NSMutableAttributedString *attrString= [[NSMutableAttributedString alloc]
                                            initWithString:string];
    long len = [attrString length];
    NSRange range = NSMakeRange(0, len);
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:range];
    [attrString addAttribute:NSFontAttributeName value:font range:range];
    
    return attrString;
}

@end
