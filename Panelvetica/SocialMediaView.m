//
//  SocialMediaView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialMediaView.h"
#import "Three20/Three20.h"

@implementation SocialMediaView

@synthesize debugView;

- (id)init {
        
    portraitDimensions = CGRectMake(40, 750, 688, 220);
    landscapeDimensions = CGRectMake(684, 280, 300, 430);
    self = [self initWithFrame:CGRectZero];
    
    [self setHeader:[UIImage imageNamed:@"socialfeed.png"]];
    debugView = [[UITextView alloc] initWithFrame:CGRectMake(60, 0, 300, 430)];
    [self addSubview:debugView];
    
    return self;
}


# pragma mark -
# pragma mark Social Media Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addNewPost:(NSString *)post 
     withUsername:(NSString *)user 
{
    NSString *post_string = [NSString stringWithFormat:@"<b>%@</b> •  %@", user, post];
    post_string = [post_string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];

    [newLbl setHtml:post_string];
    
    [self removeOldestItem];
    [newLbl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [feedText insertObject:newLbl atIndex:0];
    [self addSubview:newLbl];
    
    [self renderFeed];
    
}



@end
