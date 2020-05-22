//
//  StatsTracker.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/19/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsTracker : NSObject

+ (StatsTracker*)single;
+ (void)clearingNSUserDefaults;

- (void)track;
- (void)animationDidFinish;
- (float)getPoints;
- (int)getUsageDays;
- (BOOL)isVideoWatched;
- (BOOL)appUsageAllowed;



@end
