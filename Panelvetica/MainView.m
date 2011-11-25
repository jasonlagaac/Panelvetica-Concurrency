//
//  MainView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "TemperatureView.h"
#import "DateAndTimeView.h"
#import "ScheduleView.h"
#import "NewsFeedView.h"
#import "SocialMediaView.h"


@implementation MainView

@synthesize  dateTimeView, newsFeedView, socialMediaView, scheduleView;

- (id)init
{
    CGRect frame  = [self bounds];
    self = [super initWithFrame:frame];
        
    tempView = [[TemperatureView alloc] init];
    [self addSubview:tempView];
    
    dateTimeView = [[DateAndTimeView alloc] init];
    [self addSubview:dateTimeView];
    
    scheduleView = [[ScheduleView alloc] init];
    [self addSubview:scheduleView];
    
    newsFeedView = [[NewsFeedView alloc] init];
    [self addSubview:newsFeedView];
    
    socialMediaView = [[SocialMediaView alloc] init];
    [self addSubview:socialMediaView];
    
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
    [tempView landscapeView];
    [dateTimeView landscapeView];
    
    [socialMediaView landscapeView];
    [scheduleView landscapeView];
    [newsFeedView landscapeView];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    settingsButton.frame = CGRectMake((screen.size.height - 50), (screen.size.width - 50), 50, 50);
    reloadButton.frame = CGRectMake(0, (screen.size.width - 50), 50, 50);
    
    [self setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPortrait
{
    [tempView portraitView];
    [dateTimeView portraitView];
    
    [socialMediaView portraitView];
    [scheduleView portraitView];
    [newsFeedView portraitView];
    
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
