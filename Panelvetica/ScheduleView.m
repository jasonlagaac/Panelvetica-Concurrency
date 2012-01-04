//
//  ScheduleView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleView.h"
#import "Three20/Three20+Additions.h"


@implementation ScheduleView

- (id)init {
    portraitDimensions = CGRectMake(40, 270, 688, 220);
    landscapeDimensions = CGRectMake(40, 265, 300, 430);
    
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setHeader:[UIImage imageNamed:@"schedule.png"]];
    }
    
    return self;
}

#pragma mark -
#pragma mark Orientation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)landscapeView
{
    [self setFrame:landscapeDimensions];
    
    int pos_y = 0;
    for (int i = 0; i < [feedText count] && i < 7; i++) {
        TTStyledTextLabel *feedTxt = [feedText objectAtIndex:i];
        [feedTxt setFrame:CGRectMake(60, pos_y, 240, 61)];
        
        pos_y += 66;
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [feedTxt setHidden:NO];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)portraitView
{
    [self setFrame:portraitDimensions];
    
    for (int i = 0; i < [feedText count]; i++) {
        TTStyledTextLabel *feedTxt = [feedText objectAtIndex:i];
        switch (i) {
            case 0:
                [feedTxt setFrame:CGRectMake(60, 0, 300, 69)];
                break;
            case 1:
                [feedTxt setFrame:CGRectMake(374, 0, 300, 69)];
                break;
            case 2:
                [feedTxt setFrame:CGRectMake(60, 76, 300, 69)];
                break;
            case 3:
                [feedTxt setFrame:CGRectMake(374, 76, 300, 69)];
                break;
            case 4:
                [feedTxt setFrame:CGRectMake(60, 149, 300, 69)];
                break;
            case 5:
                [feedTxt setFrame:CGRectMake(374, 149, 300, 69)];
                break;                
            default:
                [feedTxt setHidden:YES];
                break;
        }
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addEvent:(NSString *)event 
            time:(NSString *)time 
        location:(NSString *)location
{
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
    [newLbl setHtml:[NSString stringWithFormat:@"<b>%@ • %@</b> %@", event, time, location]];
    [newLbl setBackgroundColor:[UIColor clearColor]];

    [newLbl setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [newLbl setBackgroundColor:[UIColor clearColor]];
    [newLbl setTextColor:[UIColor whiteColor]];
    [newLbl setAlpha:0.0f];
    
    [newFeedTextCache addObject:newLbl];
}

- (void)flushFeed 
{
    for (id item in feedText) {
        [item removeFromSuperview];
    }
    
    [feedText removeAllObjects];
}

# pragma mark -
# pragma mark Status Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setStatusLoading
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"scheduleLoading.png"]];
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setValue:@"1" forKey:@"fadeOut"];
    fadeOutAnimation.duration = 0.5f;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    [fadeOutAnimation setDelegate:self];
    [statusDisplay.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    
    
}

- (void)setStatusError
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"scheduleError.png"]];
}

- (void)setStatusNoEvents
{
    if ([statusDisplay isHidden]) 
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"scheduleNoEvents.png"]];

}

# pragma mark -
# pragma mark Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeed
{
    animatingFeed = YES;
    NSLog(@"Feed text count: %d", [newFeedTextCache count]);

    if ([newFeedTextCache count] != 0) {
        feedText = [NSMutableArray arrayWithArray:[newFeedTextCache copy]];
        
        NSLog(@"Feed text count: %d", [feedText count]);
        [newFeedTextCache removeAllObjects];
        
        // Draw them into the view
        for (id item in feedText) {
            [self addSubview:item];
        }
             
        // Set their layout
        [self renderFeed];
        
        int *pos_val = (int *) malloc(sizeof(int));
        *pos_val = 0;

        NSLog(@"FeedText Size: %d", [feedText count]);

        [UIView beginAnimations:@"fadeInItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(feedItemLoad:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:*pos_val] setAlpha:1.0f];
        
        [UIView commitAnimations];
    } else {
        [self setStatusNoEvents];
    }
}

#pragma mark -
#pragma mark Object removal actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeOldestItem 
{
    if ([feedText count] > 0 && [feedText count] == 6) {
        [[feedText lastObject] removeFromSuperview];
        [feedText removeObjectAtIndex:0];
    }
}


- (void)removeObjects:(NSMutableArray *)items
{    
    if ([items count] > 0) {
        removedObjects = [NSMutableArray arrayWithArray:[items copy]];
        
        int *pos_val = (int *) malloc(sizeof(int));
        *pos_val = 0;
        
        [UIView beginAnimations:@"fadeInItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(moveItems:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        for (id item in items) {
            NSNumber *num = item;
            int pos = [num intValue];
            [[feedText objectAtIndex:pos] setAlpha:0.0f];
        }
        
        [UIView commitAnimations];
    }
}



#pragma mark -
#pragma mark - Animation delegate actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)feedItemLoad:(NSString *)animationID 
            finished:(NSNumber *)finished 
             context:(void *)context 
{
    // Obtain the item number in the feedText array
    int *pos_val = (int *) context;
    
    // Iterate to the next item
    (*pos_val)++;
    
    if (*pos_val < [feedText count]) {

        // Render the current stuff into the feed
        [UIView beginAnimations:@"fadeInItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(feedItemLoad:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:*pos_val] setAlpha:1.0f];
        
        [UIView commitAnimations];

    } else {
        [newFeedTextCache removeAllObjects];
        animatingFeed = NO;
        
        free(context);
    }
}


- (void)moveItems:(NSString *)animationID 
         finished:(NSNumber *)finished 
          context:(void *)context 
{
    int *pos_val = (int *) context;
    
    // Remove all the old objects
    if (*pos_val == 0) {
        NSLog(@"Feed text init count: %d", [feedText count]);
        for (NSNumber *num in removedObjects) {
            [[feedText objectAtIndex:[num intValue]] removeFromSuperview];
            [feedText removeObjectAtIndex:[num intValue]];
        }
        
        [removedObjects removeAllObjects];
        removedObjects = nil;
        
        NSLog(@"After text count: %d", [feedText count]);
    }
    
    (*pos_val)++;

    // Move all the current objects up to their new places.
    if ((*pos_val - 1) < [feedText count] && [finished boolValue] == YES) {
        UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        [UIView beginAnimations:@"moveItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(moveItems:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        CGRect newFrame = [[feedText objectAtIndex:(*pos_val - 1)] frame];
                
        if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
            newFrame.origin.y = 66 * (*pos_val - 1);
            NSLog(@"bang pos_val: %d", (*pos_val - 1));

        } else {
            // Set the X origin
            if ((*pos_val % 2) == 0) {
                newFrame.origin.x = 60;
            } else {
                newFrame.origin.x = 374;
            }
            
            // Set the Y origin
            if (*pos_val <= 1) 
                newFrame.origin.y = 0;
            else if (*pos_val <= 3)
                newFrame.origin.y = 76;
            else if (*pos_val <= 5)
                newFrame.origin.y = 149;
        }
        
        [[feedText objectAtIndex:(*pos_val - 1)] setFrame:newFrame];
        [UIView commitAnimations];
        
    } else {
        // Add the new item to the feed
        // [feedText insertObject:[newFeedTextCache lastObject] atIndex:0];
        
        //[feedText insertObjects:[newFeedTextCache] atIndexes:
        NSArray *newFeed = [[newFeedTextCache reverseObjectEnumerator] allObjects];
        [feedText addObjectsFromArray:newFeed];
        
        // Set their dimensions and add them to the view
        [self renderFeed];
        
        for (TTStyledTextLabel *item in newFeedTextCache) {
            [self addSubview:item];
        }
        
        // Start the animation
        [UIView beginAnimations:@"fadeInNewItem" context:pos_val];
        [UIView setAnimationDuration:0.5f];
        
        int count = 0;
        while (count < [newFeedTextCache count]) {
            [[newFeedTextCache objectAtIndex:count] setAlpha:1.0f];
        }
        
        [UIView commitAnimations];
        
        // Remove the old objects from the cache and the feed
        [newFeedTextCache removeAllObjects];        

        animatingFeed = NO;
        free(context);
    } 
    
}

@end
