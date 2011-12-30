//
//  WeatherFeedOperation.h
//  Panelvetica
//
//  Created by Jason Lagaac on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomOperation.h"


@class LocationModel;
@class WeatherFeedModel;

@interface WeatherFeedOperation : CustomOperation
{
    LocationModel       *location;
    WeatherFeedModel    *weatherFeed;
}

- (id)initWithWeatherModel:(WeatherFeedModel *)wfm 
             locationModel:(LocationModel *)lcm;

@end
