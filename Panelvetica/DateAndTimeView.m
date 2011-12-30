//
//  DateAndTimeView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateAndTimeView.h"

@implementation DateAndTimeView

@synthesize mainTime, mainDate, worldTimes;

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        worldTimes = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialise the main time and date views
        portraitDimensions = CGRectMake(380, 30, 365, 250);
        landscapeDimensions = CGRectMake(524, 40, 462, 250);
        
        mainTimePortrait = CGRectMake(0, -10, 365, 80);
        mainTimeLandscape = CGRectMake(0, -20, 462, 100);
        mainTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [mainTime setTextAlignment:UITextAlignmentRight];
        [mainTime setBackgroundColor:[UIColor clearColor]];
        [mainTime setTextColor:[UIColor whiteColor]];

        [self addSubview:mainTime];
        
        
        mainDatePortrait = CGRectMake(0, 70, 365, 30);
        mainDateLandscape = CGRectMake(0, 70, 462, 30);
        mainDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [mainDate setTextAlignment:UITextAlignmentRight];
        [mainDate setBackgroundColor:[UIColor clearColor]];
        [mainDate setTextColor:[UIColor whiteColor]];


        [self addSubview:mainDate];
        
        
        // Initialise the world time and date views
        int portrait_y = 100;
        int landscape_y = 110;
        for (int i = 0; i < TOTAL_TIME_VIEWS; i++) {
            worldTimePortrait[i] = CGRectMake(0, portrait_y, 365, 35);
            worldTimeLandscape[i] = CGRectMake(0, landscape_y, 462, 37);
            
            [worldTimes addObject:[[UILabel alloc] initWithFrame:CGRectZero]];
            [[worldTimes lastObject] setTextAlignment:UITextAlignmentRight];
            [[worldTimes lastObject] setBackgroundColor:[UIColor clearColor]];
            [[worldTimes lastObject] setTextColor:[UIColor whiteColor]];

            [self addSubview:[worldTimes lastObject]];
             
            portrait_y += 30;
            landscape_y += 30;
        }
    }

    return self;
}

# pragma mark - Orientation actions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)landscapeFrames {
    [mainTime setFrame:mainTimeLandscape];
    [mainTime setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:100.0]];
    
    [mainDate setFrame:mainDateLandscape];
    [mainDate setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0]];
    
    for (int i = 0; i < TOTAL_TIME_VIEWS; i++) 
    {
        [[worldTimes objectAtIndex:i] setFrame:worldTimeLandscape[i]];
        [[worldTimes objectAtIndex:i] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)portraitFrames {
    [mainTime setFrame:mainTimePortrait];
    [mainTime setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:80.0]];
    
    [mainDate setFrame:mainDatePortrait];
    [mainDate setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
    
    for (int i = 0; i < TOTAL_TIME_VIEWS; i++) 
    {
        [[worldTimes objectAtIndex:i] setFrame:worldTimePortrait[i]];
        [[worldTimes objectAtIndex:i] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    }
    
}

@end
