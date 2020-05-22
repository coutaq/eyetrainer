//
//  NSDate+Today.h
//  Eyetrainer
//
//  Created by Denys Nikolayenko on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Today)

- (BOOL)isToday;
//- (NSInteger) daysSinceToday;
//- (NSDate*) midnight;
//- (NSDate*) tomorrow;
//- (NSDate*) yesterday;
//- (NSDate*) toLocalTime;
//- (NSDate*) toGlobalTime;

- (NSInteger) daysBetween:(NSDate*)secondDate;
//+ (NSDate *)dateFromStrings:(NSString *)format_str;


+ (NSDate*) today;
//+ (NSDate*) yesterday;
//+ (NSDate*) tomorrow;
//+ (NSDate*) midnight: (NSDate*) date;
//+ (BOOL)isToday:(NSDate*)date;
//+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2;

@end