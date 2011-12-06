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
    landscapeDimensions = CGRectMake(364, 280, 300, 430);
    [self setHeader:[UIImage imageNamed:@"newsfeed.png"]];
    
    return self;
}

#pragma mark -
#pragma mark Feed actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addNewEntry:(NSString *)content
            heading:(NSString *)heading
{    
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
    

    NSString *post_string = [NSString stringWithFormat:@"<b>%@</b> %@", heading, content];
    
    [newLbl setHtml:post_string];

    [self removeOldestItem];
    [feedText insertObject:newLbl atIndex:0];
    [self addSubview:newLbl];
        
    [self renderFeed];


}



@end
