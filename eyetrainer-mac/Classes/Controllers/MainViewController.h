//
//  MainViewController.h
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MainViewListener <NSObject>

-(void) launchAnimations;
-(void) launchHelp;
-(void) launchFeedback;
-(void) launchReminder;
-(void) launchPurchase;

@end

@interface MainViewController : NSViewController

@property (weak) IBOutlet NSButton* btnStart;
@property (weak) IBOutlet NSButton* btnFeedback;
@property (weak) IBOutlet NSButton* btnHelp;
@property (weak) IBOutlet NSButton *btnReminder;
@property (weak) IBOutlet NSButton* btnShare;
@property (weak) IBOutlet NSTextField *lblSubStart;
@property (weak) IBOutlet NSTextField* lblUsage;
@property (weak) IBOutlet NSTextField *lblCare;

@property(nonatomic, weak_delegate) id<MainViewListener> delegate;



-(IBAction)start:(id)sender;
-(IBAction)showHelp:(id)sender;
-(IBAction)feedback:(id)sender;
-(IBAction)share:(id)sender;

@end
