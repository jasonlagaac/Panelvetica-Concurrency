//
//  TemperatureView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TemperatureView.h"

@implementation TemperatureView

@synthesize temperature, location, header;

- (id)init
{
    if (self = [super initWithFrame:CGRectZero]) {
        // Initialise dimensions
        portraitDimensions = CGRectMake(40, 30, 330, 250);
        landscapeDimensions = CGRectMake(40, 40, 462, 250);
        
        tempFramePortrait = CGRectMake(60, -20, 270, 140);
        tempFrameLandscape = CGRectMake(60, -30, 402, 150);
        
        locationFramePortrait = CGRectMake(60, 90, 270, 110);
        locationFrameLandscape = CGRectMake(60, 120, 402, 80);
        
        // Initialise frames
        temperature = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        location = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
            
        [self addSubview:temperature];
        [self addSubview:location];
                                        
        // Place holding stuff for the mean time
        header = [[UIImageView alloc] init]; 
        header.frame = CGRectMake(0, 0, 50, 200);
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:YES];
        
        [self addSubview:header];
    }
    return self;
}


# pragma mark -
# pragma mark Orientation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)landscapeFrames 
{
    [temperature setFrame:tempFrameLandscape];
    [temperature setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:150]];

    [location setFrame:locationFrameLandscape];    
    [location setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    
    [UIView commitAnimations];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)portraitFrames 
{
    [temperature setFrame:tempFramePortrait];
    [temperature setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:100]];

    [location setFrame:locationFramePortrait];
    [location setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];

    [UIView commitAnimations];
}


# pragma mark -
# pragma mark Update actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTemperature:(NSString *)temp
               withFormat:(TemperatureFormat)format 
{
    (format == kCentigrade) ? [temperature setHtml:[NSString stringWithFormat:@"%@°C", temp]]: 
                              [temperature setHtml:[NSString stringWithFormat:@"%@°F", temp]];    
}



@end
