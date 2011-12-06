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
    landscapeDimensions = CGRectMake(40, 280, 300, 430);
    
    self = [self initWithFrame:CGRectZero];
    [self setHeader:[UIImage imageNamed:@"schedule.png"]];
    
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
        [feedTxt setFrame:CGRectMake(60, pos_y, 240, 61)];
        
        pos_y += 66;
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:16]];
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
                break;
        }
        [feedTxt setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    }
        
    [UIView commitAnimations];
}



#pragma mark -
#pragma mark Orientation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeOldestItem 
{
    if ([feedText count] > 0 && [feedText count] == 6) {
        [[feedText lastObject] removeFromSuperview];
        [feedText removeObjectAtIndex:0];
    }
}

- (void)removeObjectAtIndex:(int)index
{
    if ([feedText objectAtIndex:index]) {
        [[feedText objectAtIndex:index] removeFromSuperview];
        [feedText removeObjectAtIndex:index];
    }
    [self renderFeed];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addEvent:(NSString *)event 
            time:(NSString *)time 
        location:(NSString *)location
{
    TTStyledTextLabel *newLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
    [newLbl setHtml:[NSString stringWithFormat:@"<b>%@ • %@</b> %@", event, time, location]];
    
    //[self removeOldestItem];
    [feedText addObject:newLbl];
    [self addSubview:newLbl];
    
    [self renderFeed];
}

- (void)flushFeed 
{
    for (id item in feedText) {
        [item removeFromSuperview];
    }
    
    [feedText removeAllObjects];
}

@end
