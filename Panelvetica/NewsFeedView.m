//
//  NewsFeedView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedView.h"
#import "Three20/Three20.h"

@implementation NewsFeedView

- (id)init {
    
    self = [self initWithFrame:CGRectZero];
    portraitDimensions = CGRectMake(40, 510, 688, 220);
    landscapeDimensions = CGRectMake(364, 265, 300, 440);
    
    [self setHeader:[UIImage imageNamed:@"newsfeed.png"]];

    return self;
}

#pragma mark -
#pragma mark Feed actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addNewEntry:(NSString *)content
            heading:(NSString *)heading
               link:(NSString *)link
{    
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
    
    NSString *post_string = [NSString stringWithFormat:@"<b>%@ -</b> %@ <a href=\"%@\">more</a>", heading, content, link];
    
    [newLbl setHtml:post_string];
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


- (void)setStatusLoading
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"newsLoading.png"]];
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.duration = 1.0f;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.2f];
    fadeOutAnimation.autoreverses = YES;
    fadeOutAnimation.repeatCount = 1000;
    [statusDisplay.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
}

- (void)setStatusError
{
    if ([statusDisplay isHidden])
        [statusDisplay setHidden:NO];
    
    [statusDisplay setImage:[UIImage imageNamed:@"newsError.png"]];
}



@end
