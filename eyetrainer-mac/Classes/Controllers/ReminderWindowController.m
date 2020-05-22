//
//  ReminderViewController.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/5/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "ReminderWindowController.h"
#import "NSWindow+Fade.h"

@interface ReminderWindowController () <NSDatePickerCellDelegate>

@end

@implementation ReminderWindowController

- (void)awakeFromNib{
    [super awakeFromNib];
        
    [self.window setTitle:NSLocalizedString(@"mv_reminder", nil)];
    
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:kReminderDate];
    if(nil==date){
        date = [NSDate date];
    }
    
    [self.textualDatePicker setDateValue:date];
    [self.visualDatePicker setDateValue:date];
    
    BOOL isEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kReminderEnabled];
    
    self.toggleButton.state = isEnabled? NSOnState : NSOffState;
    
    [self setAppearanceWithNotificationsEnabled:isEnabled];
    
    [self.toggleButton setTarget:self];
    [self.toggleButton setAction:@selector(invalidateNotification)];
    
    [self.textualDatePicker setTarget:self];
    [self.textualDatePicker setAction:@selector(textualPickerDidPickDate)];
    
    [self.visualDatePicker setTarget:self];
    [self.visualDatePicker setAction:@selector(visualPickerDidPickDate)];
    
    [self.window fadeIn:self];
}

//- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate *__autoreleasing *)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval{
//    
//}

- (void)setAppearanceWithNotificationsEnabled:(BOOL) isEnabled{
    self.textualDatePicker.enabled = isEnabled;
    self.visualDatePicker.enabled = isEnabled;
    self.textualDatePicker.alphaValue = isEnabled? 1.f : 0.5f;
    self.visualDatePicker.alphaValue = isEnabled? 1.f : 0.5f;
}

- (void)visualPickerDidPickDate{
    self.textualDatePicker.dateValue = self.visualDatePicker.dateValue;
    [self invalidateNotification];
}

- (void)textualPickerDidPickDate{
    self.visualDatePicker.dateValue = self.textualDatePicker.dateValue;
    [self invalidateNotification];
}

- (void)invalidateNotification{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDate* pickedDate = self.textualDatePicker.dateValue;
    
    BOOL isEnabled = self.toggleButton.state == NSOnState;
    
    [defaults setBool:isEnabled forKey:kReminderEnabled];
    [defaults setObject:pickedDate forKey:kReminderDate];
    
    [self setAppearanceWithNotificationsEnabled:isEnabled];
    
    if(isEnabled){
        
        // 1 day
        NSDateComponents* repeatInterval = [NSDateComponents new];
        repeatInterval.day = 1;
        
        NSUserNotification* notification = [[NSUserNotification alloc] init];
        notification.deliveryDate = pickedDate;
        notification.deliveryRepeatInterval = repeatInterval;
        notification.title = NSLocalizedString(@"app_name", nil); 
//        notification.subtitle = NSLocalizedString(@"app_notification_today", nil);
        notification.informativeText = NSLocalizedString(@"app_notification_today", nil);
        notification.soundName = NSUserNotificationDefaultSoundName;
        
        notification.hasActionButton = NO;
//        notification.actionButtonTitle  = @"OK";
        
        [NSUserNotificationCenter defaultUserNotificationCenter]. scheduledNotifications = @[notification];
    }else{
        
        [NSUserNotificationCenter defaultUserNotificationCenter].scheduledNotifications = @[];
    }
    [defaults synchronize];
}

-(BOOL)windowShouldClose:(id)sender{
    [self.window fadeOut:self];
    return NO;
}

@end
