//
//  ScheduleFeedViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleView;

@interface ScheduleFeedViewController : UIViewController
{
    ScheduleView    *scheduleView;
}

@property (nonatomic, strong) ScheduleView *scheduleView;

@end
