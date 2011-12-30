//
//  SocialMediaView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialMediaView.h"
#import "Three20/Three20.h"

@interface SocialMediaView (Private)
- (void)loadFeed;
- (void)renderNewPost;

@end

@implementation SocialMediaView

- (id)init {
        
    portraitDimensions = CGRectMake(40, 750, 688, 220);
    landscapeDimensions = CGRectMake(684, 265, 300, 440);

    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        [self setHeader:[UIImage imageNamed:@"socialfeed.png"]];
    }
    
    return self;
}


# pragma mark -
# pragma mark Social Media Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addNewPost:(NSString *)post 
     withUsername:(NSString *)user 
{
    //[self removeOldestItem];
    
    NSString *post_string = [NSString stringWithFormat:@"<b>%@</b> •  %@", user, post];
    post_string = [post_string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    post_string = [post_string stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"];
    post_string = [post_string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
    [newLbl setText:[TTStyledText textFromXHTML:post_string lineBreaks:NO URLs:YES]];

    [newLbl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [newLbl setBackgroundColor:[UIColor clearColor]];
    [newLbl setTextColor:[UIColor whiteColor]];
    [newLbl setAlpha:0.0f];
    
    [newFeedTextCache insertObject:newLbl atIndex:0];
    
    
    // Operation when the application is loaded or the feed is reloaded
    if ([feedText count] == 0 && [newFeedTextCache count] == 4) {
        // Copy the newFeedTextCache to feedText.
        // Render feed with segments gradually appearing.
        // Flush the newFeedTextCache.
        [self loadFeed];        
    }
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
    [UIScrollView setAnimationDelegate:self];    
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
        [UIScrollView setAnimationDelegate:self];    
        [UIView setAnimationDidStopSelector:@selector(moveItems:finished:context:)];
        [UIView setAnimationDuration:0.5f];
        
        [[feedText objectAtIndex:*pos_val] setAlpha:0.0f];
        
        [UIView commitAnimations];
    }
}



# pragma mark -
# pragma mark Feed Status Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStatusLoading
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"socialLoading.png"]];
    CABasicAnimation *fadeOutStatusAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fadeOutStatusAnimation.duration = 1.0f;
    fadeOutStatusAnimation.removedOnCompletion = NO;
    fadeOutStatusAnimation.fillMode = kCAFillModeForwards;
    fadeOutStatusAnimation.toValue = [NSNumber numberWithFloat:0.2f];
    fadeOutStatusAnimation.autoreverses = YES;
    fadeOutStatusAnimation.repeatCount = 1000;
    
    [statusDisplay.layer addAnimation:fadeOutStatusAnimation forKey:@"animateOpacity"];
}

- (void)setStatusError
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"socialError.png"]];
}

@end

