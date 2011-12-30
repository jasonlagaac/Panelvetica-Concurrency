//
//  TemperatureView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "InfoView.h"
#import "WeatherFeedModel.h"
#import "Three20/Three20.h"

@interface WeatherView : InfoView
{
    TTStyledTextLabel   *temperature;
    TTStyledTextLabel   *location;
    UIImageView         *header;

    
    CGRect              tempFramePortrait;
    CGRect              tempFrameLandscape;
    
    CGRect              locationFramePortrait;
    CGRect              locationFrameLandscape;
    
    UIImageView         *statusDisplay;
    BOOL                loading;
}


@property (retain, nonatomic) TTStyledTextLabel *temperature;
@property (retain, nonatomic) TTStyledTextLabel *location;
@property BOOL loading;

- (void)setTemperature:(int)temp
            withFormat:(TempFormat)format
              location:(NSString *)loc;

- (void)setHeader:(UIImage *)img;
- (void)setStatusLoading;
- (void)hideStatusDisplay;
- (void)setInfoVisible;



@end
