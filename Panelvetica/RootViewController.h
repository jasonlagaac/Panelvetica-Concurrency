//
//  RootViewController.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@class RootView;
@class SettingsModel;

@class SocialFeedViewController;
@class SocialFeedOperation;

@class NewsFeedViewController;

@class ScheduleFeedViewController;

@interface RootViewController : UIViewController 
{
    RootView                    *rootView;
    SettingsModel               *settings;
    NSTimer                     *updateTimer;
    
    SocialFeedViewController    *socialFeedViewController;
    SocialFeedOperation         *socialFeedOper;
    
    // NOTE: There is no NewsFeedOperation as TTURLRequest 
    // already does operations concurrently.
    NewsFeedViewController      *newsFeedViewController;
    
    ScheduleFeedViewController  *scheduleFeedViewController;
    
    // Operation Queue
    NSOperationQueue            *operationQueue;
}

@property (strong, nonatomic) SettingsModel   *settings;

@end
