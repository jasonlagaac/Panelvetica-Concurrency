//
//  SocialMediaView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialMediaView.h"
#import "SocalFeedLabel.h"

@implementation SocialMediaView

- (id)init {
        
    portraitDimensions = CGRectMake(40, 750, 688, 220);
    landscapeDimensions = CGRectMake(684, 280, 300, 430);
    self = [self initWithFrame:CGRectZero];
    
    [self setHeader:[UIImage imageNamed:@"socialfeed.png"]];
    
    return self;
}

# pragma mark -
# pragma mark Orientation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)landscapeView
{
    [self setFrame:landscapeDimensions];
    [self setBackgroundColor:[UIColor clearColor]];
    
    int pos_y = 0;
    for (int i = 0; i < [feedText count]; i++) {
        SocalFeedLabel *feedTxt = [feedText objectAtIndex:i];
        [feedTxt setFrame:CGRectMake(60, pos_y, 240, 120)];
        
        pos_y += 125;
        
        [feedTxt setNeedsDisplay];
        [[feedTxt status_text] setFont:[UIFont fontWithName:@"Helvetica" size:13]];

    }
}

- (void)portraitView
{
    [self setFrame:portraitDimensions];
    [self setBackgroundColor:[UIColor clearColor]];
    
    for (int i = 0; i < [feedText count]; i++) {
        SocalFeedLabel *feedTxt = [feedText objectAtIndex:i];
        switch (i) {
            case 0:
                [feedTxt setFrame:CGRectMake(60, 0, 300, 105)];
                break;
            case 1:
                [feedTxt setFrame:CGRectMake(374, 0, 300, 105)];
                break;
            case 2:
                [feedTxt setFrame:CGRectMake(60, 115, 300, 105)];
                break;
            case 3:
                [feedTxt setFrame:CGRectMake(374, 115, 300, 105)];
                break;
            default:
                break;
        }        
    }
        
    [UIView commitAnimations];
}

# pragma mark -
# pragma mark Social Media Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addNewPost:(NSString *)post 
     withUsername:(NSString *)user 
           avatar:(UIImage *)avatar 
{
    SocalFeedLabel *newLbl = [[SocalFeedLabel alloc] initWithFrame:CGRectZero];
    [newLbl setPost:post withUsername:user avatar:avatar];
    
    [self removeOldestItem];
    [feedText insertObject:newLbl atIndex:0];
    [self addSubview:[feedText objectAtIndex:0]];
    
    [self renderFeed];
    
}



@end
