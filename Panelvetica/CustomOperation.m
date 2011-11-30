//
//  CustomOperation.m
//  Panelvetica
//
//  Created by Jason Lagaac on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

#pragma mark - Concurrency Methods
////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isConcurrent 
{
    return YES;
}

- (BOOL)isFinished 
{
    return finished;
}

- (BOOL)isExecuting 
{
    return executing;
}


- (void)start 
{
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) 
                             toTarget:self 
                           withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark - Marker methods
////////////////////////////////////////////////////////////////////////////////////////
- (void)completedOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


@end
