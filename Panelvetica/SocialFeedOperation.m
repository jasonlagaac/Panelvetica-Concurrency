//
//  SocialFeedOperation.m
//  Panelvetica
//
//  Created by Jason Lagaac on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialFeedOperation.h"
#import "SocialFeedModel.h"

@implementation SocialFeedOperation

- (id)initWithSocialFeed:(SocialFeedModel *)sf 
{
    self = [super init];
    
    if (self) {
        socialFeed = sf;
        
        [socialFeed addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0 
                        context:nil];
        
        executing = NO;
        finished = NO;
    }
    
    return self;
}

- (void)main
{
    [socialFeed fetchTimeline];
}


#pragma mark - Marker methods
////////////////////////////////////////////////////////////////////////////////////////

- (void)completedOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [socialFeed removeObserver:self
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
        if ([object isEqual:socialFeed]) {
            [self completedOperation];
        }
    }
}


@end
