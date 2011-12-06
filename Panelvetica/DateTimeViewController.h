//
//  DateTimeViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 3/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateAndTimeView;

@interface DateTimeViewController : UIViewController
{
    NSMutableArray *timeZones;
    DateAndTimeView *dateTimeView;
}

@property (nonatomic, strong) DateAndTimeView  *dateTimeView;

- (void)dateTimeViewUpdate;

@end
