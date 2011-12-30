//
//  FeedView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define TOTAL_SEG 4

@interface FeedView : UIView
{
    UIImageView     *header;
    CGRect          landscapeDimensions;
    CGRect          portraitDimensions;
    
    UIImageView     *statusDisplay;
    
    NSMutableArray  *feedText;
    NSMutableArray  *newFeedTextCache;  
    
    BOOL            animatingFeed;
    NSTimer         *feedDrawTimer;
    
}

@property (nonatomic, retain) NSMutableArray *feedText;

- (void)landscapeView;
- (void)portraitView;
- (void)setHeader:(UIImage *)img;
- (void)removeOldestItem;
- (void)renderFeed;

- (void)hideStatusDisplay;

- (void)loadFeed;
- (void)renderNewPost;
- (void)feedItemLoad:(NSString *)animationID 
            finished:(NSNumber *)finished 
             context:(void *)context;

- (void)moveItems:(NSString *)animationID 
         finished:(NSNumber *)finished 
          context:(void *)context;





@end
