//
//  MainView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootView.h"
#import "TemperatureView.h"
#import "DateAndTimeView.h"
#import "ScheduleView.h"
#import "NewsFeedView.h"
#import "SocialMediaView.h"


@implementation RootView

- (id)init
{
    CGRect frame  = [self bounds];
    self = [super initWithFrame:frame];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"settings-pressed.png"] forState:UIControlStateHighlighted];
    [self addSubview:settingsButton];
    
    reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    [reloadButton setImage:[UIImage imageNamed:@"reload-pressed.png"] forState:UIControlStateHighlighted];
    [self addSubview:reloadButton];

    return self;
}

#pragma mark - Orientation actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setLandscape 
{
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    settingsButton.frame = CGRectMake((screen.size.height - 50), (screen.size.width - 50), 50, 50);
    reloadButton.frame = CGRectMake(0, (screen.size.width - 50), 50, 50);
    
    [self setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPortrait
{
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    settingsButton.frame = CGRectMake((screen.size.width - 50), (screen.size.height - 50), 50, 50);
    reloadButton.frame = CGRectMake(0, (screen.size.height - 50), 50, 50);
    
    [self setNeedsDisplay];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadView 
{


}

@end
