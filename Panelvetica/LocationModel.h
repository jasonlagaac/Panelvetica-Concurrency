//
//  LocationModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Three20/Three20.h"

@interface LocationModel : TTURLRequestModel <CLLocationManagerDelegate> 
{
    CLLocationManager       *locationManager;
    CLLocation              *currLocation;
    
    BOOL                    finished;
    int                     woeid;
}

@property (nonatomic, strong) CLLocation *currLocation;
@property int woeid;

- (void)fetchCurrentLocation;
- (BOOL)isFinished;

@end
