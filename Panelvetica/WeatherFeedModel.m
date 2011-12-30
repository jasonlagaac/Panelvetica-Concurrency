//
//  WeatherFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherFeedModel.h"
#import "extThree20XML/extThree20XML.h"


@implementation WeatherFeedModel

@synthesize  location, tempUnit, temperature, conditions;

- (id)initWithUnit:(TempFormat)u {
    self = [super init];
    
    if (self) {
        temperature = 0;
        conditions = 0;
        tempUnit = u;
        
        changedConditions =  NO;
        finished = NO;
    }
    
    return self;
}

- (void)fetchWeather:(int)w
{
    woeid = w;
    [self load:TTURLRequestCachePolicyNone more:NO];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy 
        more:(BOOL)more
{
    if (!self.isLoading) {
        NSString *feedURL = nil;
        
        if (tempUnit == kTemperatureCelsius)
            feedURL = @"http://weather.yahooapis.com/forecastrss?w=%d&u=c";
        else
            feedURL = @"http://weather.yahooapis.com/forecastrss?w=%d&u=f";
        

        NSString *feed = [NSString stringWithFormat:feedURL, woeid];
        
        TTURLRequest *request = [TTURLRequest requestWithURL:feed delegate:self];
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
        
        // This tells the URLRequest to return an XML Document (RSS)
        TTURLXMLResponse* response = [[TTURLXMLResponse alloc] init];
        response.isRssFeed = YES; // Make sure Items are grouped together
        request.response = response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [request send];
        });

        changedConditions = NO;
        finished = NO;
    }

}

- (void)requestDidFinishLoad:(TTURLRequest *)request 
{
    TTURLXMLResponse *response = (TTURLXMLResponse*) request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *feed = response.rootObject;
    TTDASSERT([[feed objectForKey:@"channel"] isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *cond = [[[feed objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"yweather:condition"];
    int currCondition = [[cond objectForKey:@"code"] intValue];
    
    if (currCondition != conditions) {
        conditions = currCondition;
        changedConditions =  YES;
    }
    
    temperature = [[cond objectForKey:@"temp"] intValue];
    location = [[[feed objectForKey:@"channel"] objectForKey:@"yweather:location"] objectForKey:@"city"];
        
    [super requestDidFinishLoad:request];	
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)isFinished 
{
    return finished;
}

- (BOOL)hasChangedConditions
{
    return changedConditions;
}


@end
