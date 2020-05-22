//
//  ReminderViewController.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/5/14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ReminderWindowController : NSWindowController

@property (strong) IBOutlet NSDatePicker *visualDatePicker;
@property (strong) IBOutlet NSDatePicker *textualDatePicker;
@property (strong) IBOutlet NSButton *toggleButton;

@end
