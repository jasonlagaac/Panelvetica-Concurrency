//
//  FeedView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOTAL_SEG 4

@interface FeedView : UIView
{
    UIImageView *header;
    CGRect landscapeDimensions;
    CGRect portraitDimensions;
    
    NSMutableArray *feedText;
}

@property (nonatomic, retain) NSMutableArray *feedText;

- (void)landscapeView;
- (void)portraitView;
- (void)setHeader:(UIImage *)img;
- (void)removeOldestItem;
- (void)renderFeed;


@end
