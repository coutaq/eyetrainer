//
//  StatsTracker.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/19/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "StatsTracker.h"
#import "NSDate+Today.h"

static StatsTracker* instance;

@implementation StatsTracker

+(StatsTracker*) single {
    if (!instance) {
        instance = [[StatsTracker alloc] init];
    }
//    [self clearingNSUserDefaults];
    return instance;
}

-(id) init {
    self = [super init];
    if(self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults objectForKey:kFirstDate]){
            [defaults setObject:[NSDate today] forKey: kFirstDate];
            [defaults setObject:[NSDate today] forKey: kLastDate];
            [defaults setObject:@(0.0) forKey: kPoints];
            [defaults setObject:@(1) forKey: kRunDaysCount];
            [defaults setObject:@(1) forKey: kUsageDays];
            [defaults setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:kLastRewardDate];
        }
        [defaults synchronize];
    }
    return self;
}

-(void) track {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDate* lastUsageDate = (NSDate*) [defaults objectForKey:kLastDate];
    if(![lastUsageDate isToday]) {
        NSDate* today = [NSDate today];
        int days = [[defaults objectForKey:kRunDaysCount] intValue];
        [defaults setObject:[NSNumber numberWithInt:days+1] forKey:kRunDaysCount];
        [defaults setObject:today forKey:kLastDate];
        
        NSDate* firstUsageDate = [defaults objectForKey:kFirstDate];
        NSInteger usageDays = [today daysBetween:firstUsageDate];
        [defaults setObject:@(usageDays+1) forKey:kUsageDays];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeUsageDays object:nil];
    }
}

- (void)animationDidFinish
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastRewardDate = [defaults objectForKey:kLastRewardDate];
    NSDate* lastUsageDate = [defaults objectForKey:kLastDate];

    if ([lastUsageDate daysBetween:lastRewardDate] >= 1) {
        [defaults setObject:[NSDate today] forKey: kLastRewardDate];

        float totalPoints = [[defaults objectForKey:kPoints] floatValue] + kDefaultPoints;
        if (totalPoints > 100) {
            totalPoints = 100;
        }
        [defaults setObject:@(totalPoints) forKey:kPoints];
        [defaults synchronize];
    }
}

-(float)getPoints {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kPoints] floatValue];
}

-(int) getUsageDays {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kUsageDays] floatValue];
}

-(BOOL) isVideoWatched{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:kVideoWatched]){
        [defaults setBool:YES forKey:kVideoWatched];
        [defaults synchronize];
        return NO;
    }
    return YES;
}

+(void) clearingNSUserDefaults {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * keys = [defaults dictionaryRepresentation];
    for (id key in keys) {
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
}

-(BOOL) appUsageAllowed{

#if APP_IN_DEBUG == 1
    return YES;
#else
    int days = [[[NSUserDefaults standardUserDefaults] objectForKey:kRunDaysCount] intValue];
    return days<=kEstimatedTrialDays;
#endif
}

@end
