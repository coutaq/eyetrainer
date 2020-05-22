//
//  NSDate+Today.m
//  Eyetrainer
//
//  Created by Denys Nikolayenko on 9/4/12.
//
//

#import "NSDate+Today.h"

#define DAY (24 * 60 * 60)

@implementation NSDate (Today)

- (BOOL)isToday {
    return [NSDate isToday:self];
}

- (NSInteger) daysBetween:(NSDate*)secondDate {
    NSTimeInterval x = self.timeIntervalSince1970;
    NSTimeInterval y = secondDate.timeIntervalSince1970;
    return (x - y) / DAY;
}

+ (NSDate*) today {
    return [self midnight:[NSDate date]];
}

+ (NSDate*) midnight: (NSDate*) date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate: date];
    return [gregorian dateFromComponents: components];
}

+ (BOOL)isToday:(NSDate*)date {
    return [self isSameDay: date otherDay: [NSDate date]];
}

+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

//- (NSDate*) toLocalTime
//{
//    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
//    NSInteger seconds = [tz secondsFromGMTForDate: self];
//    return [NSDate dateWithTimeInterval:seconds sinceDate: self];
//}
//
//- (NSDate*) toGlobalTime
//{
//    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
//    NSInteger seconds = -[tz secondsFromGMTForDate: self];
//    return [NSDate dateWithTimeInterval:seconds sinceDate: self];
//}
//
//+ (NSDate *)dateFromStrings:(NSString *)format_str
//{
//    NSDateFormatter *df;
//    df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//    return [df dateFromString:format_str];
//}

//+ (NSDate*) yesterday {
//    return [self midnight:[NSDate dateWithTimeIntervalSinceNow:(-DAY)]];
//}
//
//+ (NSDate*) tomorrow {
//    return [self midnight:[NSDate dateWithTimeIntervalSinceNow:(DAY)]];
//}

//- (NSDate*) midnight {
//    return [NSDate midnight:self];
//}

//- (NSDate*) tomorrow {
//    return [NSDate dateWithTimeInterval:DAY sinceDate:self];
//}
//
//- (NSDate*) yesterday {
//    return [NSDate dateWithTimeInterval:-DAY sinceDate:self];
//}

//- (NSInteger) daysSinceToday {
//    NSTimeInterval x = self.timeIntervalSince1970;
//    NSTimeInterval y = [NSDate today].timeIntervalSince1970;
//
//    return (x - y) / DAY;
//}

@end
