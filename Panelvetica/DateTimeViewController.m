//
//  DateTimeViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 3/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateTimeViewController.h"
#import "DateAndTimeView.h"

@interface DateTimeViewController (Private)
- (NSString *)ordinatedDay:(char *)ordVal;
- (NSMutableString *)formattedZone:(NSString *)zone;
@end

@implementation DateTimeViewController

@synthesize dateTimeView;

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        dateTimeView = [[DateAndTimeView alloc] init];
        [self setView:dateTimeView];
        timeZones = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Timer Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dateTimeViewUpdate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *currentDate = [[NSDateFormatter alloc] init];
    
    // Set the main time display
    NSDateFormatter *currentTime = [[NSDateFormatter alloc] init];
    currentTime.dateFormat = @"hh:mm a";
    [[dateTimeView mainTime] setText:[currentTime stringFromDate:now]];
    
    // Set the main date display
    currentDate.dateFormat = @"d";
    char ordVal = [[currentDate stringFromDate:now] length] < 2 ? [[currentDate stringFromDate:now] characterAtIndex:0] : 
    [[currentDate stringFromDate:now] characterAtIndex:1];
    
    currentDate.dateFormat = [NSString stringWithFormat:@"EEE • %@ 'of' MMMM • YYYY", [self ordinatedDay:ordVal]];
    [[dateTimeView mainDate] setText:[currentDate stringFromDate:now]];
    
    // Set the additional time displays
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"Australia/Sydney"]];
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    
    int count = 0;
    for (NSTimeZone *zone in timeZones) {
        if (count < 3) {
            [currentDate setTimeZone:zone];
            currentDate.dateFormat = @"d";
            
            currentDate.dateFormat = @"hh:mm a • EEE • dd/MM/yyyy • ";
            [[[dateTimeView worldTimes] objectAtIndex:count] setText:[NSString stringWithFormat:@"%@ %@", 
                                                                                  [currentDate stringFromDate:now], 
                                                                                  [self formattedZone:[zone name]]]];
            count++;
        }   
    }
}


#pragma mark - Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)ordinatedDay:(char *)ordVal
{    
    NSNumberFormatter * day = [[NSNumberFormatter alloc] init];
    [day setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * dayval = [day numberFromString:[NSString stringWithFormat:@"%c",ordVal]];
    
    NSString *newDayFormat = nil;
    switch ([dayval intValue])
    {
        case 1:
            newDayFormat = [NSString stringWithString:@"d'st'"];
            break;
        case 2:
            newDayFormat = [NSString stringWithString:@"d'nd'"];
            break;
        case 3:
            newDayFormat = [NSString stringWithString:@"d'rd'"];
            break;
        default:
            newDayFormat = [NSString stringWithString:@"d'th'"];
            break;
    }
    
    return newDayFormat;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableString *)formattedZone:(NSString *)zone
{
    NSMutableString *city = [NSMutableString stringWithString:[[zone componentsSeparatedByString:@"/"] lastObject]];
    [city replaceOccurrencesOfString:@"_" 
                          withString:@" " 
                             options:0
                               range:NSMakeRange(0, [city length])];
    
    return city;
}
@end
