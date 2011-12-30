//
//  RootViewController.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "Three20/Three20.h"

@class RootView;
@class SettingsModel;

@class SocialFeedViewController;
@class SocialFeedOperation;

@class ScheduleFeedViewController;
@class ScheduleFeedOperation;

@class NewsFeedViewController;
@class NewsFeedOperation;

@class DateTimeViewController;

@class WeatherFeedOperation;
@class WeatherViewController;

@class NavigationController;
@class WebViewController;

@interface RootViewController : UIViewController <TTNavigatorDelegate>
{
    RootView                    *rootView;
    SettingsModel               *settings;
    NSTimer                     *updateTimer;
    NSTimer                     *dateTimeTimer;
    
    // Views and their associated operations
    SocialFeedViewController    *socialFeedViewController;
    SocialFeedOperation         *socialFeedOper;
    
    ScheduleFeedViewController  *scheduleFeedViewController;
    ScheduleFeedOperation       *scheduleFeedOper;
    
    NewsFeedViewController      *newsFeedViewController;
    NewsFeedOperation           *newsFeedOper;
    
    DateTimeViewController      *dateTimeViewController;
    
    WeatherViewController       *weatherViewController;
    WeatherFeedOperation        *weatherFeedOper;
    
    // Operation Queue
    NSOperationQueue            *operationQueue;
    
    TTNavigator                 *navigator;
    NavigationController        *navViewController;
    WebViewController           *webViewController;
}

@property (strong, nonatomic) SettingsModel   *settings;


@end
