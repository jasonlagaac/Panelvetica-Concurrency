//
//  ScheduleFeedViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFeedViewController.h"
#import "ScheduleView.h"
#import "ScheduleFeedModel.h"

@interface ScheduleFeedViewController (Private)
- (void) reloadFeed;
@end

@implementation ScheduleFeedViewController

@synthesize  scheduleView, scheduleFeed;

- (id)init 
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        scheduleView = [[ScheduleView alloc] init];
        scheduleFeed = [[ScheduleFeedModel alloc] init];
        upcomingEvents = [[NSMutableArray alloc] init];
        [self setView:scheduleView];
    }
    
    return self;
}

- (void)feedUpdate
{
    // Sort the array by time
    NSDate *today = [NSDate date];

    if ([scheduleFeed isUpdated]) {
        // Allocate some events 
        [self reloadFeed];
    } else {
        // Remove the past events as time progresses
        for (int i = 0; i < [upcomingEvents count]; i++) {
            EKEvent *event = [upcomingEvents objectAtIndex:i];
            
            NSDate *eventStart = [event startDate];
            double timeInterval = [today timeIntervalSinceDate:eventStart];
            
            if (timeInterval > 120) {
                [upcomingEvents removeObjectAtIndex:i];
                [scheduleView removeObjectAtIndex:i];
            }
        }
        
        if ([[scheduleView feedText] count] < 6) {
            for (int i = [[scheduleView feedText] count]; i < 6 && i < [upcomingEvents count]; i++) {
                EKEvent *event = [upcomingEvents objectAtIndex:i];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"hh:mm a";
                NSDate *startTime = [event startDate];
                
                NSString *title = [event title];
                NSString *location = nil;
                
                if ([event location])
                    location = [event location];
                else
                    location = [NSString stringWithString:@""];
                
                
                [scheduleView addEvent:title 
                                  time:[dateFormatter stringFromDate:startTime]  
                              location:location];
            }
        }
    }
}

- (void)reloadFeed 
{
    NSArray *events = [[[self scheduleFeed] events] sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    NSDate *today = [NSDate date];

    [scheduleView flushFeed];
    [upcomingEvents removeAllObjects];
    
    for (EKEvent *event in events) {
        NSDate *eventStart = [event startDate];
        double timeInterval = [today timeIntervalSinceDate:eventStart];
        
        if (timeInterval < 300) {
            [upcomingEvents addObject:event];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            NSDate *startTime = [event startDate];
            
            NSString *title = [event title];
            NSString *location = nil;
            
            if ([event location])
                location = [event location];
            else
                location = [NSString stringWithString:@""];
            
            
            [scheduleView addEvent:title 
                              time:[dateFormatter stringFromDate:startTime]  
                          location:location];
        }
    }
}


@end
