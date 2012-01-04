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
        currentEvents = [[NSMutableArray alloc] init];
        
        isLoaded = NO;
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
        NSMutableArray *removedItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < [currentEvents count]; i++) {
            EKEvent *event = [currentEvents objectAtIndex:i];
            
            NSDate *eventStart = [event startDate];
            double timeInterval = [today timeIntervalSinceDate:eventStart];
            
            if (timeInterval > 60) {
                [removedItems addObject:[NSNumber numberWithInt:i]];
            }
        }
        
        // Remove items
        for (NSNumber *num in removedItems) {
            [currentEvents removeObjectAtIndex:[num intValue]];
        }
        
        [scheduleView removeObjects:removedItems];
        
        
        if ([currentEvents count] < 7) {
            if ([upcomingEvents count] > 0) {
                while (([currentEvents count] < 7) && ([upcomingEvents count] > 0)) {
                    EKEvent *event = [upcomingEvents objectAtIndex:1];
                    [currentEvents addObject:event];
                    [upcomingEvents removeObjectAtIndex:1];
                    
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
        
        [removedItems removeAllObjects];
    } 
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Schedule Items: %d", [[scheduleFeed events] count]);
        if ([currentEvents count] == 0 && isLoaded == NO) {
            isLoaded = YES;
            [scheduleView setStatusNoEvents];
        }  else if ([currentEvents count] != 0 && isLoaded == NO) {
            // Load the feed 
            isLoaded = YES;
            [[self scheduleView] hideStatusDisplay];
            [[self scheduleView] loadFeed];
        }
    });
    
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
        
        // Add all objects that are within the 24 hour period
        // into an array
        if (timeInterval < 300) {
            [upcomingEvents addObject:event];
        }
    }
    
    // Draw add the top 7 upcoming events within the view
    while (([currentEvents count] < 7) && ([upcomingEvents count] > 0)) {
        EKEvent *event = [upcomingEvents objectAtIndex:1];
        [currentEvents addObject:event];
        [upcomingEvents removeObjectAtIndex:1];
        
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


@end
