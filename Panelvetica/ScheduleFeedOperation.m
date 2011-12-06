//
//  ScheduleFeedOperation.m
//  Panelvetica
//
//  Created by Jason Lagaac on 5/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFeedOperation.h"
#import "ScheduleFeedModel.h"

@implementation ScheduleFeedOperation
- (id)initWithScheduleFeed:(ScheduleFeedModel *)sfm
{
    self = [super init];
    
    if (self) {
        scheduleFeed = sfm;
        
        [scheduleFeed addObserver:self
                       forKeyPath:@"isFinished" 
                          options:0 
                          context:nil];
        
        finished = NO;
        executing = NO;
    }
    
    return self;
}

- (void)main
{
    [scheduleFeed fetchEvents];
}

#pragma mark - Marker methods
////////////////////////////////////////////////////////////////////////////////////////

- (void)completedOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [scheduleFeed removeObserver:self
                    forKeyPath:@"isFinished"];
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"]) {
        if ([object isEqual:scheduleFeed]) {
            [self completedOperation];
        }
    }
}

@end
