//
//  ScheduleView.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedView.h"

#define TOTAL_SEG_SCHED 7

@interface ScheduleView : FeedView
{
    NSMutableArray  *removedItemsCache;
}

- (void)addEvent:(NSString *)event 
            time:(NSString *)time 
        location:(NSString *)location;

- (void)removeObjectAtIndex:(int)index;
- (void)flushFeed;

- (void)setStatusLoading;
- (void)setStatusError;
- (void)setStatusNoEvents;

- (void)loadFeed;

@end
