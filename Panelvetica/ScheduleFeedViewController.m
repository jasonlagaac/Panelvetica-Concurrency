//
//  ScheduleFeedViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFeedViewController.h"
#import "ScheduleView.h"

@implementation ScheduleFeedViewController

@synthesize  scheduleView;

- (id)init 
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        scheduleView = [[ScheduleView alloc] init];
        [self setView:scheduleView];
    }
    
    return self;
}


@end
