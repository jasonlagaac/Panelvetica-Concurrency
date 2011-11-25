//
//  DateAndTimeView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"
#import "Three20/Three20.h"

#define TOTAL_TIME_VIEWS 3

@interface DateAndTimeView : InfoView
{
    // Define elements
    UILabel *mainTime;
    UILabel *mainDate;
    
    // Define dimensions
    CGRect mainTimePortrait;
    CGRect mainTimeLandscape;
    
    CGRect mainDatePortrait;
    CGRect mainDateLandscape;
    
    NSMutableArray *worldTimes;

    CGRect worldTimeLandscape[3];
    CGRect worldTimePortrait[3];
}

@property (nonatomic, retain) UILabel *mainTime;
@property (nonatomic, retain) UILabel *mainDate;
@property (nonatomic, retain) NSMutableArray *worldTimes;


@end
