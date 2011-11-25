//
//  MainView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemperatureView;
@class DateAndTimeView;
@class ScheduleView;
@class NewsFeedView;
@class SocialMediaView;

@interface MainView : UIView
{
    TemperatureView     *tempView;
    DateAndTimeView     *dateTimeView;
    ScheduleView        *scheduleView;
    NewsFeedView        *newsFeedView;
    SocialMediaView     *socialMediaView;
    
    UIButton            *settingsButton;
    UIButton            *reloadButton;
}

@property (nonatomic, retain) DateAndTimeView *dateTimeView;
@property (nonatomic, retain) NewsFeedView    *newsFeedView;
@property (nonatomic, retain) SocialMediaView *socialMediaView;
@property (nonatomic, retain) ScheduleView    *scheduleView;

- (void)setPortrait;
- (void)setLandscape;
- (void)reloadView;

@end
