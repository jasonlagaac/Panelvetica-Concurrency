//
//  ScheduleFeedViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleView;
@class ScheduleFeedModel;

@interface ScheduleFeedViewController : UIViewController
{
    ScheduleView        *scheduleView;
    ScheduleFeedModel   *scheduleFeed;
    NSMutableArray      *upcomingEvents;
}

@property (nonatomic, strong) ScheduleView      *scheduleView;
@property (nonatomic, strong) ScheduleFeedModel *scheduleFeed;

- (void)feedUpdate;


@end
