//
//  WeatherFeedViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationModel;
@class WeatherFeedModel;
@class WeatherView;

@interface WeatherViewController : UIViewController
{
    LocationModel       *location;
    WeatherFeedModel    *weatherFeed;
    WeatherView         *weatherView;
}

@property (nonatomic, strong) LocationModel       *location;
@property (nonatomic, strong) WeatherFeedModel    *weatherFeed;
@property (nonatomic, strong) WeatherView         *weatherView;

- (void)feedUpdate;

@end
