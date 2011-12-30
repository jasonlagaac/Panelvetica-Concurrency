//
//  TemperatureView.m
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

@synthesize temperature, location, loading;

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
        
        [temperature setBackgroundColor:[UIColor clearColor]];
        [location setBackgroundColor:[UIColor clearColor]];
        
        [temperature setTextColor:[UIColor whiteColor]];
        [location setTextColor:[UIColor whiteColor]];
        
        statusDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 340, 340)];
        statusDisplay.contentMode = UIViewContentModeTopLeft;
        
        [temperature setAlpha:0.0f];
        [location setAlpha:0.0f];

        [self addSubview:temperature];
        [self addSubview:location];
                                        
        // Place holding stuff for the mean time
        header = [[UIImageView alloc] init]; 
        header.frame = CGRectMake(0, 0, 50, 200);
        [header setAlpha:0.0f];
        
        self.loading = YES;

        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:YES];
        
        [self addSubview:statusDisplay];
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
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)portraitFrames 
{
    [temperature setFrame:tempFramePortrait];
    [temperature setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:100]];

    [location setFrame:locationFramePortrait];
    [location setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
}

# pragma mark -
# pragma mark Update actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTemperature:(int)temp
               withFormat:(TempFormat)format
                location:(NSString *)loc
{
    (format == kTemperatureCelsius) ? [temperature setHtml:[NSString stringWithFormat:@"%d°C", temp]]: 
                              [temperature setHtml:[NSString stringWithFormat:@"%@°F", temp]];  
    [location setHtml:loc];
}

- (void)setHeader:(UIImage *)img
{
    [header setImage:img];
}

# pragma mark -
# pragma mark Loading views
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStatusLoading
{
    self.loading = YES;
    
    [statusDisplay setImage:[UIImage imageNamed:@"weatherLoading.png"]];
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.duration = 1.0f;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeOutAnimation.repeatCount = 1000;
    fadeOutAnimation.autoreverses = YES;
    [fadeOutAnimation setDelegate:self];
    
    [statusDisplay.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
}

- (void)setInfoVisible 
{
    self.loading = NO;
    [UIView beginAnimations:@"fadeInItemInFeed" context:nil];
    [UIView setAnimationDuration:1.0f];
    
    [temperature setAlpha:1.0f];
    [location setAlpha:1.0f];
    [header setAlpha:1.0f];

    
    [UIView commitAnimations];
}

- (void)hideStatusDisplay
{
    [statusDisplay setHidden:YES];
}



@end
