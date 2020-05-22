//
//  HelpWindowController.m
//  eyetrainer-mac
//
//  Created by Aleksey Kuznetsov on 30.01.14.
//  Copyright (c) 2014 StepInMobile. All rights reserved.
//

#import "HelpWindowController.h"
#import "NSWindow+Fade.h"

@interface HelpWindowController ()

@end

@implementation HelpWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self fillText];
    [self.window fadeIn:self];
}

-(void)fillText{
    
    [self.window setTitle:NSLocalizedString(@"hv_title", nil)];

    NSString *line = @"\n";
    NSString *space = @" ";
    
    [self.btnVideo setTitle: NSLocalizedString(@"hv_video", nil)];

    [self.labelDisclaimer setStringValue:NSLocalizedString(@"hv_disclaimer_title", nil)];

    [self.labelHintEyesight setStringValue:NSLocalizedString(@"hv_eyes", nil)];

    [self.textInfo setStringValue:NSLocalizedString(@"hv_info", nil)];

    NSMutableString *disclaimerText = [NSMutableString stringWithString:NSLocalizedString(@"hv_disclaimer", nil)];
    [disclaimerText appendString:space];
    [disclaimerText appendString: NSLocalizedString(@"hv_best_result", nil)];
    [disclaimerText appendString:line];
    [disclaimerText appendString: NSLocalizedString(@"hv_restrictions", nil)];
    [self.textDisclaimer setStringValue:disclaimerText];
    
    NSMutableString *poseHint = [NSMutableString stringWithString:NSLocalizedString(@"hv_pose", nil)];
    [poseHint appendString:line];
    [poseHint appendString: NSLocalizedString(@"hv_remove_glasses", nil)];
    [self.labelHintPose setStringValue:poseHint];
    
    NSMutableString *ipadHint = [NSMutableString stringWithString:NSLocalizedString(@"hv_ipad_one", nil)];
    [ipadHint appendString:line];
    [ipadHint appendString: NSLocalizedString(@"hv_ipad_two", nil)];
    [ipadHint appendString:line];
    [ipadHint appendString: NSLocalizedString(@"hv_ipad_three", nil)];
    [self.labelHintIpad setStringValue:ipadHint];

    NSMutableString *buttonHint = [NSMutableString stringWithString:NSLocalizedString(@"hv_button_one", nil)];
    [buttonHint appendString:line];
    [buttonHint appendString: NSLocalizedString(@"hv_button_two", nil)];
    [buttonHint appendString:line];
    [buttonHint appendString: NSLocalizedString(@"hv_button_three", nil)];
    [self.labelHintButton setStringValue:buttonHint];

}

- (IBAction)launchVideo:(id)sender {
    if(self.delegate)
        [self.delegate launchVideo];
}

-(BOOL)windowShouldClose:(id)sender{
    [self.window fadeOut:self];
    return NO;
}

@end
