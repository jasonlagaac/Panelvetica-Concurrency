//
//  RootViewController.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@class MainView;
@class NewsFeedModel;
@class SocialFeedModel;
@class SettingsModel;

@interface RootViewController : UIViewController 
{
    MainView        *main_view;
    
    NSTimer         *dateTimeTimer;
    NSTimer         *feedTimer;
    NSTimer         *socialFeedTimer;
    
    NSMutableArray  *timeZones;
    NewsFeedModel   *newsFeed;
    SocialFeedModel *socialFeed;
    
    SettingsModel   *settings;
    
    NSMutableArray  *currentNewsFeed;
}

@property (strong, nonatomic)SettingsModel   *settings;

@end
