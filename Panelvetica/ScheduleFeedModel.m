//
//  ScheduleFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 4/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFeedModel.h"

@implementation ScheduleFeedModel

@synthesize events;

- (id)init 
{
    self = [super init];
    
    if (self) {
        eventStore = [[EKEventStore alloc] init];
        feedUpdated = NO;
        finished = NO;
    }
    
    return self;
}

- (void)fetchEvents
{
    finished = NO;
    feedUpdated = NO;
    
    CFGregorianDate gregStartDate, gregEndDate;
    CFGregorianUnits startUnits = { 0, 0, 0, 0, 0, 0 };
    CFGregorianUnits endUnits = { 0, 0, 1, 0, 0, 0 };
    
    CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
    
    gregStartDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, startUnits), timeZone);
    gregStartDate.hour = 0;
    gregStartDate.minute = 0;
    gregStartDate.second = 0;
    
    gregEndDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, endUnits), timeZone);
    gregEndDate.hour = 0;
    gregEndDate.minute = 0;
    gregEndDate.second = 0;
    
    NSDate  *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregStartDate, timeZone)];
    NSDate  *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregEndDate, timeZone)];
    
    CFRelease(timeZone);
    
    NSPredicate *prediate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    
    [self setEvents:[eventStore eventsMatchingPredicate:prediate]];
    
    if (currItemCount != [events count]) {
        [self willChangeValueForKey:@"isUpdated"];
        feedUpdated = YES;
        currItemCount = [events count];
        [self didChangeValueForKey:@"isUpdated"];
    }
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];

}

- (BOOL)isFinished
{
    return finished;
}

- (BOOL)isUpdated;
{
    return feedUpdated;
}



@end
