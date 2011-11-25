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
    feedText = [[NSMutableArray alloc] init];    
    
    return self;
}

#pragma mark -
#pragma mark Orientation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)landscapeView
{
    [self setFrame:landscapeDimensions];
    [self setBackgroundColor:[UIColor clearColor]];
    
    int pos_y = 0;
    for (int i = 0; i < [feedText count]; i++) {
        TTStyledTextLabel *feedTxt = [feedText objectAtIndex:i];
        [feedTxt setFrame:CGRectMake(60, pos_y, 240, 90)];
        
        pos_y += 110;
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    }
    
    [UIView commitAnimations];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)portraitView
{
    [self setFrame:portraitDimensions];
    [self setBackgroundColor:[UIColor clearColor]];

    
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
            
    [UIView commitAnimations];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma makr Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeader:(UIImage *)img 
{
    header = [[UIImageView alloc] initWithImage:img];
    header.frame = CGRectMake(0, 0, 50, 220);
    [self addSubview:header];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)removeOldestItem 
{
    if ([feedText count] > 0 && [feedText count] == 4) {
        [[feedText lastObject] removeFromSuperview];
        [feedText removeLastObject];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)renderFeed {
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(currentOrientation))
        [self landscapeView];
    else
        [self portraitView];
}



@end
