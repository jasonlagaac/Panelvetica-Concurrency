//
//  LocationModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationModel.h"
#import "extThree20XML/extThree20XML.h"

#define YAHOO_API_KEY  @"KoxuciDV34GT_7MU2lN09XuAZaCRtXTaGaoYrsw7qXVVvmnTssKnmgFp__QQn1wtoCYv7X7NXNjA4MqMxSQxxxMyJRmg04U-"

@implementation LocationModel
@synthesize currLocation, woeid;

- (id)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];

        finished = NO;
    }
    
    return self;
}

#pragma mark - Weather Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy 
        more:(BOOL)more
{
    NSString *feedURL = @"http://where.yahooapis.com/geocode?q=%f,%f&gflags=R&appid=%@";
    
    if (!self.isLoading) {
        // We create a new Request for the BuildMobile RSS feed
        // requestDidFinishLoad will be called once the request has ended
        CLLocationDegrees latitude = currLocation.coordinate.latitude;
        CLLocationDegrees longitude = currLocation.coordinate.longitude;
        
        NSString *feed = [NSString stringWithFormat:feedURL, latitude,longitude, YAHOO_API_KEY];
        TTURLRequest *request = [TTURLRequest requestWithURL:feed delegate:self];
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
        
        // This tells the URLRequest to return an XML Document (RSS)
        TTURLXMLResponse* response = [[TTURLXMLResponse alloc] init];
        response.isRssFeed = YES; // Make sure Items are grouped together
        request.response = response;
        //TT_RELEASE_SAFELY(response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [request send];
        });
        
        finished = NO;
    }
    
}

- (void)requestDidFinishLoad:(TTURLRequest *)request 
{
    TTURLXMLResponse *response = (TTURLXMLResponse*) request.response;

    //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);

    NSDictionary *feed = response.rootObject;
    //TTDASSERT([[feed objectForKey:@"Result"] isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *result = [[feed objectForKey:@"Result"] objectForKey:@"woeid"];
    NSString *woeidValue = [result objectForKey:@"___Entity_Value___"];
    woeid = [woeidValue intValue];

    [locationManager stopUpdatingLocation];
    
    [super requestDidFinishLoad:request];	
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - Location Manager Operations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    currLocation = newLocation;
    [self load:TTURLRequestCachePolicyNone more:YES];
}

- (void)fetchCurrentLocation
{
    [locationManager startUpdatingLocation];
}


- (BOOL)isFinished
{
    return finished;
}

@end
