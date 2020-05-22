//
//  MainViewController.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/15/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "MainViewController.h"
#import "StatsTracker.h"
#import "Utils.h"
#import "NSAttributedString+Utils.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cangeUsageDays:)
                                                     name:kChangeUsageDays
                                                   object:nil];
    }
    return self;
}

-(void) awakeFromNib{
    [super awakeFromNib];
    [self loadDesign];
}

-(void) loadDesign{
    
    [self configureButton:self.btnHelp withString:NSLocalizedString(@"mv_help", @"Help fff")];
    [self configureButton:self.btnFeedback withString:NSLocalizedString(@"mv_feedback", @"Feedback fff")];
    [self configureButton:self.btnReminder withString:NSLocalizedString(@"mv_reminder", @"Reminder")];
      [self configureButton:self.btnShare withImage:(@"NSImageNameShareTemplate")];

    NSString *startBtnString = NSLocalizedString(@"mv_start", @"Start fff");
    [self.btnStart setAttributedTitle: [NSAttributedString centeredStringWithString:startBtnString
                                                                              andFont:[self fontBold]
                                                                              ofColor:[self pointsColor]]];

    NSString *subStartLabelString = NSLocalizedString(@"mv_session", @"EyeCare fff");
    [self.lblSubStart setAttributedStringValue: [NSAttributedString centeredStringWithString:subStartLabelString
                                                                                       andFont:[self fontLight]
                                                                                       ofColor:[self pointsColor]]];
    
    NSString *careLabelString = NSLocalizedString(@"mv_look_after", @"care fff");
    [self.lblCare setAttributedStringValue: [NSAttributedString centeredStringWithString:careLabelString
                                                                                   andFont:[self fontItalic]
                                                                                   ofColor:[self careColor]]];
    
    [self.btnShare sendActionOn:NSLeftMouseDownMask];
    
    [self setUsagelabel];
}

-(void) cangeUsageDays:(NSNotification*)notification {
    [self setUsagelabel];
}
-(void) setUsagelabel {
    NSMutableAttributedString * usageLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    int days = [[StatsTracker single] getUsageDays];
    NSString *string = [NSString stringWithFormat:@"%i", days];
    NSAttributedString *subString = [NSAttributedString centeredStringWithString:string
                                                                           andFont:[self fontNormal] ofColor:[self daysColor]];
    [usageLabelAttributedString appendAttributedString:subString];
    
    NSString *dayDeclension = getDeclensionForNumber(days, NSLocalizedString(@"app_day", @"day fff"), NSLocalizedString(@"app_days_234_ru", @"days_234"), NSLocalizedString(@"app_days", @"days_fff"));
    string = [NSString stringWithFormat:@" %@ ", dayDeclension];
    subString = [NSAttributedString centeredStringWithString:string andFont:[self fontLight] ofColor:[self daysColor]];
    [usageLabelAttributedString appendAttributedString:subString];
    
    float points = [[StatsTracker single] getPoints];
    string = [NSString stringWithFormat:@"%.f", points];
    subString = [NSAttributedString centeredStringWithString:string andFont:[self fontNormal] ofColor:[self pointsColor]];
    [usageLabelAttributedString appendAttributedString:subString];
    
    string = NSLocalizedString(@"app_point", @"point fff");
    subString = [NSAttributedString centeredStringWithString:string andFont:[self fontLight] ofColor:[self pointsColor]];
    [usageLabelAttributedString appendAttributedString:subString];
    
    [self.lblUsage setAttributedStringValue:usageLabelAttributedString];
}

- (IBAction)start:(id)sender {
    if(self.delegate){
        [self.delegate launchAnimations];
    }
}

-(IBAction)showHelp:(id)sender {
    if(self.delegate){
        [self.delegate launchHelp];
    }
}

-(IBAction)feedback:(id)sender {
    if(self.delegate){
        [self.delegate launchFeedback];
    }
}

- (IBAction)showReminder:(id)sender {
    if(self.delegate){
        [self.delegate launchReminder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSFont*) fontNormal {
    return [NSFont fontWithName:@"DroidSans-Bold" size:25];
}
-(NSFont*) fontBold {
    return [NSFont fontWithName:@"DroidSans-Bold" size:40];
}
-(NSFont*) fontItalic {
    return [NSFont fontWithName:@"Palatino-Italic" size:17];
}
-(NSFont*) fontLight {
    return [NSFont fontWithName:@"DroidSans" size:20];
}
-(NSFont*) btnFont {
    return [NSFont fontWithName:@"LucidaGrande" size:12];
}
-(NSColor*) daysColor{
    return [NSColor colorWithDeviceRed: 0.6 green:0.8 blue:0.8 alpha:1.0];
}
-(NSColor*) pointsColor{
    return [NSColor whiteColor];
}
-(NSColor*) careColor{
    return [NSColor colorWithDeviceRed:0.6 green:0.6 blue:0.6 alpha:1.0];
}
-(NSColor*) alternateColor{
    return [NSColor colorWithDeviceRed:35./255 green:94./255 blue:151./255 alpha:1];
}

-(void) configureButton:(NSButton*)button withString:(NSString*)string {
    [button setAttributedTitle: [NSAttributedString centeredStringWithString:string
                                                                       andFont:[self btnFont]
                                                                       ofColor:[self daysColor]]];
    [button setAttributedAlternateTitle:[NSAttributedString centeredStringWithString:string
                                                                               andFont:[self btnFont]
                                                                               ofColor:[self alternateColor]]];
}
-(void) configureButton:(NSButton*)button withImage:(NSString*)string {
    [button setImage: [NSImage imageNamed:string]];
}

 
- (IBAction)shareOnTwitter:(id)sender
{
    NSMutableString *text = [NSMutableString string];
    [text appendString:@"I scored "];
    
    float points = [[StatsTracker single] getPoints];
     NSString *score = [NSString stringWithFormat:@"%i"];
     score = [NSString stringWithFormat:@"%.f", points];
     [text appendString:score];
     [text appendString:@"% on как там оно называется.  итут еще типо наверн ссылка будет на аппстор? мб картинка?"];
    //NSImage *image = [NSImage imageNamed:@"NSImageNameShareTemplate"];
    NSArray * shareItems = [NSArray arrayWithObjects:text, nil];
    
    NSSharingServicePicker *sharingPicker = [[NSSharingServicePicker alloc] initWithItems:shareItems];
    [sharingPicker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}
@end
