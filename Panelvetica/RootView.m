//
//  MainView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootView.h"
#import <QuartzCore/QuartzCore.h>


@implementation RootView

- (id)init
{
    CGRect frame  = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:frame];
    if (self) {
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testimg.jpg"]];
        backgroundImage.alpha = 0.60;
    
        [self addSubview:backgroundImage];
        [self sendSubviewToBack:backgroundImage];
    
        
        [self addSubview:opacityLayer];
        [self insertSubview:opacityLayer aboveSubview:backgroundImage];
         
        settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
        [settingsButton setImage:[UIImage imageNamed:@"settings-pressed.png"] forState:UIControlStateHighlighted];
        [settingsButton setUserInteractionEnabled:YES];
        [self addSubview:settingsButton];
        
        reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
        [reloadButton setImage:[UIImage imageNamed:@"reload-pressed.png"] forState:UIControlStateHighlighted];
        [reloadButton setUserInteractionEnabled:YES];
        [self addSubview:reloadButton];
        
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

#pragma mark - Orientation actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setLandscape 
{
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    settingsButton.frame = CGRectMake((screen.size.height - 50), (screen.size.width - 50), 50, 50);
    reloadButton.frame = CGRectMake(0, (screen.size.width - 50), 50, 50);
    backgroundImage.frame = CGRectMake(0, 0, screen.size.height, screen.size.width);
    backgroundImage.contentMode = UIViewContentModeScaleToFill;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPortrait
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    settingsButton.frame = CGRectMake((screen.size.width - 50), (screen.size.height - 50), 50, 50);
    reloadButton.frame = CGRectMake(0, (screen.size.height - 50), 50, 50);
    backgroundImage.frame = screen;
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadView 
{


}

@end
