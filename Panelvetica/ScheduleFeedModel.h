//
//  ScheduleFeedModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 4/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ScheduleFeedModel : NSObject
{
    NSArray         *events;
    EKEventStore    *eventStore;
    
    BOOL            finished;
    BOOL            feedUpdated;
    int             currItemCount;
    
}

@property (nonatomic, strong) NSArray *events;

- (void)fetchEvents;
- (BOOL)isFinished;
- (BOOL)isUpdated;


@end
