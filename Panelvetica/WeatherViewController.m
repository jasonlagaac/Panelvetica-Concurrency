//
//  WeatherFeedViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherView.h"
#import "LocationModel.h"
#import "WeatherFeedModel.h"

@interface WeatherViewController (Private) 
- (void)updateHeader;
@end

@implementation WeatherViewController
@synthesize location, weatherFeed, weatherView;

- (id)init 
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        location = [[LocationModel alloc] init];
        weatherFeed = [[WeatherFeedModel alloc] initWithUnit:kTemperatureCelsius];
        weatherView = [[WeatherView alloc] init];
        
        [self setView:weatherView];
    }
    
    return self;
}

- (void)feedUpdate
{
    if ([weatherView loading]) {
        [weatherView hideStatusDisplay];
        [weatherView setInfoVisible];
    }
    
    if ([weatherFeed hasChangedConditions]) {
        [weatherView setTemperature:[weatherFeed temperature] 
                         withFormat:[weatherFeed tempUnit] 
                           location:[weatherFeed location]];
        [self updateHeader];
    }
}

- (void)updateHeader
{
    UIImage *img;
    
    switch ([weatherFeed conditions]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 37:
        case 38:
        case 39:
            NSLog(@"Storm");
            img = [UIImage imageNamed:@"storm.png"];
            break;
        
        case 5:
        case 7:
        case 13:
        case 14:
        case 15:
        case 16:
        case 41:
        case 42:
        case 43:
        case 46:
            NSLog(@"Snow");
            img = [UIImage imageNamed:@"snow.png"];
            break;
            
        case 8:
        case 9:
            NSLog(@"Drizzle");
            img = [UIImage imageNamed:@"drizzle.png"];
            break;
            
        case 6:
        case 18:
            NSLog(@"Sleet");
            img = [UIImage imageNamed:@"sleet.png"];
            break;
            
        case 11:
        case 12:
        case 40:
        case 45:
        case 47:
            NSLog(@"Shower");
            img = [UIImage imageNamed:@"shower.png"];
            break;
        
        case 26:
        case 27:
        case 28:
        case 29:
        case 30:
            NSLog(@"Cloudy");
            img = [UIImage imageNamed:@"cloudy.png"];
            break;
            
        case 17:
        case 35:
            NSLog(@"Hail");
            img = [UIImage imageNamed:@"hail.png"];
            break;
            
        case 19:
            NSLog(@"Dust");
            break;

        case 20:
            NSLog(@"Fog");
            img = [UIImage imageNamed:@"fog.png"];
            break;

        case 21:
            NSLog(@"Haze");
            img = [UIImage imageNamed:@"haze.png"];
            break;

        case 22:
            NSLog(@"Smoke");
            img = [UIImage imageNamed:@"smoke.png"];
            break;
            
        case 23:
        case 24:
            NSLog(@"Windy");
            img = [UIImage imageNamed:@"wind.png"];
            break;
        
        case 25:
            NSLog(@"Cold");
            img = [UIImage imageNamed:@"cold.png"];
            break;
        
        case 31:
            NSLog(@"Clear");
            img = [UIImage imageNamed:@"clear.png"];
            break;
            
        case 32:
            NSLog(@"Sunny");
            img = [UIImage imageNamed:@"sunny.png"];
            break;
            
        case 33:
        case 34:
            NSLog(@"Fair");
            img = [UIImage imageNamed:@"fair.png"];
            break;
        
        case 36:
            NSLog(@"Hot");
            img = [UIImage imageNamed:@"hot.png"];
            break;

        default:
            break;
    }
    
    [weatherView setHeader:img];
}



@end
