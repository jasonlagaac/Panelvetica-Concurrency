//
//  TemperatureView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "InfoView.h"
#import "Three20/Three20.h"

typedef enum {
    kCentigrade = 0,
    kFahrenheit
} TemperatureFormat;

@interface TemperatureView : InfoView
{
    TTStyledTextLabel *temperature;
    TTStyledTextLabel *location;
    UIImageView *header;

    
    CGRect tempFramePortrait;
    CGRect tempFrameLandscape;
    
    CGRect locationFramePortrait;
    CGRect locationFrameLandscape;
}


@property (retain, nonatomic) TTStyledTextLabel *temperature;
@property (retain, nonatomic) TTStyledTextLabel *location;
@property (retain, nonatomic) UIImageView *header;

@end
