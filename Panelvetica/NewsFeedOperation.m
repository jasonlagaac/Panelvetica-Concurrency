//
//  NewsFeedOperation.m
//  Panelvetica
//
//  Created by Jason Lagaac on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedOperation.h"
#import "NewsFeedModel.h"

@implementation NewsFeedOperation

- (id)initWithNewsFeed:(NewsFeedModel *)nfm
{
    self = [super init];
    
    if (self) {
        newsFeed = nfm;
        [newsFeed addObserver:self 
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
    [newsFeed fetchFeed];
}

- (void)completedOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [newsFeed removeObserver:self
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
        if ([object isEqual:newsFeed]) {
            [self completedOperation];
        }
    }
}

@end
