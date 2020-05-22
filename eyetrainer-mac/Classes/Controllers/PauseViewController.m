//
//  PauseViewController.m
//  eyetrainer-mac
//
//  Created by Denys Nikolayenko on 2/20/13.
//  Copyright (c) 2013 StepInMobile. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()
@property (weak) IBOutlet NSButton *continueButton;
@property (weak) IBOutlet NSButton *stopButton;

@end

@implementation PauseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

-(void) awakeFromNib{
    [super awakeFromNib];

    //fix unintelligible bug
    NSButtonCell *stopButtonCell = self.stopButton.cell;
    [stopButtonCell.image setSize:self.stopButton.frame.size];
    [stopButtonCell.alternateImage setSize:self.stopButton.frame.size];
    NSButtonCell *continueButtonCell = self.continueButton.cell;
    [continueButtonCell.image setSize:self.continueButton.frame.size];
    [continueButtonCell.alternateImage setSize:self.continueButton.frame.size];
}

-(IBAction)stopAnimation:(id)sender{
    if(self.delegate){
        [self.delegate quitAnimation];
    }    
}

-(IBAction)resumeAnimation:(id)sender{
    if(self.delegate){
        [self.delegate resumeAnimation];
    }
}

-(void) dealloc{
    self.delegate = nil;
}

@end
