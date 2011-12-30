//
//  WeatherFeedOperation.m
//  Panelvetica
//
//  Created by Jason Lagaac on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherFeedOperation.h"
#import "LocationModel.h"
#import "WeatherFeedModel.h"

@implementation WeatherFeedOperation

- (id)initWithWeatherModel:(WeatherFeedModel *)wfm 
             locationModel:(LocationModel *)lcm
{
    self = [super init];
    
    if (self) {
        location = lcm;
        weatherFeed = wfm;

        [location addObserver:self
                      forKeyPath:@"isFinished" 
                         options:0 
                         context:nil];
        
        [weatherFeed addObserver:self
                   forKeyPath:@"isFinished" 
                      options:0 
                      context:nil];
         

        finished = NO;
        executing = NO;
    }

    return self;
}

- (void)main
{
    // Fetch the location first. Once the operation is completed,
    // the observer will kick off the operation to fetch the 
    // weather data.
    [location fetchCurrentLocation];
}

#pragma mark - Marker methods
////////////////////////////////////////////////////////////////////////////////////////

- (void)completedOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [weatherFeed removeObserver:self
                      forKeyPath:@"isFinished"];
    
    [location removeObserver:self
                     forKeyPath:@"isFinished"];
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"]) {
        if ([object isEqual:weatherFeed]) {
            [self completedOperation];
        }
    }
    
    if ([keyPath isEqualToString:@"isFinished"]) {
        if ([object isEqual:location]) {
            NSLog(@"WOEID %d", [location woeid]);
            [weatherFeed fetchWeather:[location woeid]];
        }
    }
}
@end
