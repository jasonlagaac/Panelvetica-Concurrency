//
//  WeatherFeedModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

typedef enum {
    kTemperatureFahrenheit = 0,
    kTemperatureCelsius
} TempFormat;

@interface WeatherFeedModel : TTURLRequestModel
{
    NSString    *location;
    TempFormat  tempUnit;
    int         woeid;
    
    int         temperature;
    int         conditions;
    
    BOOL        finished;
    BOOL        changedConditions;
}

@property (nonatomic, strong) NSString  *location;
@property TempFormat tempUnit;
@property int temperature;
@property int conditions;

- (id)initWithUnit:(TempFormat)u;
- (void)fetchWeather:(int)woeid;
- (BOOL)isFinished;
- (BOOL)hasChangedConditions;

@end
