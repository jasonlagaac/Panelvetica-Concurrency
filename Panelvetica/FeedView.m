//
//  FeedView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedView.h"
#import "Three20/Three20+Additions.h"

@implementation FeedView
@synthesize  feedText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        feedText = [[NSMutableArray alloc] init]; 
        newFeedTextCache = [[NSMutableArray alloc] init];
        
        statusDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 240, 200)];
        statusDisplay.contentMode = UIViewContentModeTopLeft;
        
        animatingFeed = NO;
        
        [self addSubview:statusDisplay];
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
    for (int i = 0; i < [feedText count]; i++) {
        TTStyledTextLabel *feedTxt = [feedText objectAtIndex:i];
        [feedTxt setFrame:CGRectMake(60, pos_y, 240, 110)];
        
        pos_y += 125;

        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    }
}

- (void)portraitView
{
    [self setFrame:portraitDimensions];
    
    for (int i = 0; i < [feedText count]; i++) {
        TTStyledTextLabel *feedTxt = [feedText objectAtIndex:i];            
        
        switch (i) {
            case 0:
                [feedTxt setFrame:CGRectMake(60, 0, 300, 100)];
                break;
            case 1:
                [feedTxt setFrame:CGRectMake(374, 0, 300, 100)];
                break;
            case 2:
                [feedTxt setFrame:CGRectMake(60, 115, 300, 100)];
                break;
            case 3:
                [feedTxt setFrame:CGRectMake(374, 115, 300, 100)];
                break;
            default:
                break;
        }
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    }
}


#pragma mark -
#pragma makr Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeader:(UIImage *)img 
{
    header = [[UIImageView alloc] initWithImage:img];
    header.frame = CGRectMake(0, 0, 50, 220);
    [self addSubview:header];
}

-(void)removeOldestItem 
{
    if ([feedText count] > 0 && [feedText count] == 4) {
        [[feedText lastObject] removeFromSuperview];
        [feedText removeLastObject];
    }
}

- (void)renderFeed 
{
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation))
        [self landscapeView];
    else
        [self portraitView];
    
    [self setNeedsDisplay];
}



#pragma mark -
#pragma mark Animation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)hideStatusDisplay
{
    [statusDisplay setHidden:YES];
}

# pragma mark -
# pragma mark Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeed
{
    animatingFeed = YES;
    
    // Copy the feed items available
    feedText = [NSMutableArray arrayWithArray:[newFeedTextCache copy]];
    [newFeedTextCache removeAllObjects];
    
    // Draw them into the view
    for (id item in feedText) {
        [self addSubview:item];
    }
    
    // Set their layout
    [self renderFeed];
    
    int *pos_val = (int *) malloc(sizeof(int));
    *pos_val = 0;
    
    [UIView beginAnimations:@"fadeInItemInFeed" context:pos_val];
    [UIView setAnimationDelegate:self];    
    [UIView setAnimationDidStopSelector:@selector(feedItemLoad:finished:context:)];
    [UIView setAnimationDuration:0.5f];
    
    [[feedText objectAtIndex:*pos_val] setAlpha:1.0f];
    
    [UIView commitAnimations];
}

- (void)renderNewPost
{
    if ([newFeedTextCache count] > 0 && animatingFeed == NO) {
        int *pos_val = (int *) malloc(sizeof(int));
        *pos_val = [feedText count] - 1;
        
        animatingFeed = YES;
        
        [UIView beginAnimations:@"removeOldItem" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(moveItems:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:*pos_val] setAlpha:0.0f];
        
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
    
    if (*pos_val < 4) {
        [UIView beginAnimations:@"fadeInItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(feedItemLoad:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:*pos_val] setAlpha:1.0f];
        
        [UIView commitAnimations];
    } else {
        [newFeedTextCache removeAllObjects];
        feedDrawTimer = [NSTimer timerWithTimeInterval:5.0f
                                                target:self 
                                              selector:@selector(renderNewPost) 
                                              userInfo:nil 
                                               repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:feedDrawTimer
                                     forMode:NSRunLoopCommonModes];
        
        animatingFeed = NO;
        free(context);
    }
}


- (void)moveItems:(NSString *)animationID 
         finished:(NSNumber *)finished 
          context:(void *)context 
{
    int *pos_val = (int *) context;
    (*pos_val)--;
    
    if (*pos_val >= 0 && [finished boolValue] == YES) {
        UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        
        [UIView beginAnimations:@"moveItemInFeed" context:pos_val];
        [UIView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(moveItems:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        CGRect newFrame = [[feedText objectAtIndex:*pos_val] frame];
        
        if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
            newFrame.origin.y += 125;
        } else {
            if ((*pos_val % 2) == 0) {
                newFrame.origin.x = 374;
                [[feedText objectAtIndex:*pos_val] setFrame:newFrame];
            } else {
                newFrame.origin.x = 60;
                newFrame.origin.y = 115;
                [[feedText objectAtIndex:*pos_val] setFrame:newFrame];
            }
        }
        
        [[feedText objectAtIndex:*pos_val] setFrame:newFrame];
        [UIView commitAnimations];
        
    } else {
        // Add the new item to the feed
        [feedText insertObject:[newFeedTextCache lastObject] atIndex:0];
        
        // Remove the old objects from the cache and the feed
        [newFeedTextCache removeLastObject];
        [[feedText lastObject] removeFromSuperview];
        [feedText removeLastObject];
        
        // Set their dimensions and add them to the view
        [self renderFeed];
        [self addSubview:[feedText objectAtIndex:0]];
        
        
        // Start the animation
        [UIView beginAnimations:@"fadeInNewItem" context:pos_val];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:0] setAlpha:1.0f];
        
        [UIView commitAnimations];
        
        animatingFeed = NO;
        free(context);
    }
}

@end

