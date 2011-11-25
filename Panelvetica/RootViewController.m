//
//  RootViewController.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MainView.h"

#import "DateAndTimeView.h"
#import "TemperatureView.h"

#import "SocialMediaView.h"
#import "NewsFeedView.h"
#import "ScheduleView.h"

#import "NewsFeedModel.h"
#import "SocialFeedModel.h"
#import "SocialFeedItem.h"

#import "SettingsModel.h"


@interface RootViewController (PrivateMethods)
- (void)dateTimeViewUpdate;
- (void)newsFeedUpdate;
- (void)socialFeedUpdate;

- (NSMutableString *)formattedZone:(NSString *)zone;
- (NSMutableString *)ordinatedDay:(char *)day;
@end


@implementation RootViewController
@synthesize settings;

- (id)init 
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        settings = [[SettingsModel alloc] init];
        newsFeed = [[NewsFeedModel alloc] initWithRSSFeed:@"http://rss.cnn.com/rss/edition.rss"];
        [newsFeed load:TTURLRequestCachePolicyNoCache more:NO];
                        
        currentNewsFeed = [[NSMutableArray alloc] init];
        timeZones = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
    main_view = [[MainView alloc] init];
    [main_view setBackgroundColor:[UIColor clearColor]];
    [self setView:main_view];
    
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || 
        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        [main_view setLandscape];
    } else {
        [main_view setPortrait];
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) 
                                             target:self 
                                           selector:@selector(dateTimeViewUpdate) 
                                           userInfo:nil 
                                            repeats:YES];
    

    
    feedTimer = [NSTimer scheduledTimerWithTimeInterval:(2.0)
                                             target:self 
                                               selector:@selector(newsFeedUpdate) 
                                               userInfo:nil 
                                                repeats:YES];
    
    socialFeedTimer = [NSTimer scheduledTimerWithTimeInterval:(5.0)
                                                 target:self 
                                               selector:@selector(socialFeedUpdate) 
                                               userInfo:nil 
                                                repeats:YES];
     
        
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated 
{    
    socialFeed = [[SocialFeedModel alloc] initWithAccount:[[settings accounts] objectAtIndex:0]];
}

#pragma mark - Rotation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || 
        toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [main_view setPortrait];
    } else
        [main_view setLandscape];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    
}

#pragma mark - Timer actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dateTimeViewUpdate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *currentDate = [[NSDateFormatter alloc] init];

    // Set the main time display
    NSDateFormatter *currentTime = [[NSDateFormatter alloc] init];
    currentTime.dateFormat = @"hh:mm a";
    [[[main_view dateTimeView] mainTime] setText:[currentTime stringFromDate:now]];
    
    // Set the main date display
    currentDate.dateFormat = @"d";
    char ordVal = [[currentDate stringFromDate:now] length] < 2 ? [[currentDate stringFromDate:now] characterAtIndex:0] : 
                                                              [[currentDate stringFromDate:now] characterAtIndex:1];
    
    currentDate.dateFormat = [NSString stringWithFormat:@"EEE • %@ 'of' MMMM • YYYY", [self ordinatedDay:ordVal]];
    [[[main_view dateTimeView] mainDate] setText:[currentDate stringFromDate:now]];
    
    
    // Set the additional time displays
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"Australia/Sydney"]];
    [timeZones addObject:[NSTimeZone timeZoneWithName:@"America/New_York"]];

    int count = 0;
    for (NSTimeZone *zone in timeZones) {
        if (count < 3) {
            [currentDate setTimeZone:zone];
            currentDate.dateFormat = @"d";
        
            currentDate.dateFormat = @"h:mm a • EEE • dd/MM/yyyy • ";
            [[[[main_view dateTimeView] worldTimes] objectAtIndex:count] setText:[NSString stringWithFormat:@"%@ %@", 
                                                        [currentDate stringFromDate:now], 
                                                        [self formattedZone:[zone name]]]];
            count++;
        }   
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newsFeedUpdate
{
    if ([currentNewsFeed count] == 0) {
        [currentNewsFeed addObjectsFromArray:[newsFeed items]];
        for (NSDictionary *item in [newsFeed items]) {
            NSDictionary *titleElement = [item objectForKey:@"title"];
            NSDictionary *descriptionElement = [item objectForKey:@"description"];
            //NSDictionary *linkElement = [item objectForKey:@"link"];

            [[main_view newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                          heading:[titleElement objectForKey:@"___Entity_Value___"]];
            
        }
    } else if (![currentNewsFeed isEqualToArray:[newsFeed items]]) { 
        for (int i = ([[newsFeed items] count] - 1); i >= 0; i--) {
            NSDictionary *item = [[newsFeed items] objectAtIndex: i];
            
            if ([[[currentNewsFeed objectAtIndex:0] objectForKey:@"pubDate"] compare:[item objectForKey:@"pubDate"]] 
                != NSOrderedSame) {
                [currentNewsFeed removeLastObject];
                [currentNewsFeed insertObject:item atIndex:0];
                
                NSDictionary *titleElement = [item objectForKey:@"title"];
                NSDictionary *descriptionElement = [item objectForKey:@"description"];
                
                [[main_view newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                              heading:[titleElement objectForKey:@"___Entity_Value___"]];
                
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socialFeedUpdate
{
    [socialFeed fetchTimeline];
    if ([socialFeed isUpdated]) {
        for (id item in [socialFeed currentPosts]) {
            NSLog(@"%@", [item tweet]);
            TWRequest *fetchUserImageRequest = [[TWRequest alloc] 
                                                initWithURL:[item profileImageURL]
                                                parameters:nil
                                                requestMethod:TWRequestMethodGET];
            [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if ([urlResponse statusCode] == 200) {
                    UIImage *profileImage = [UIImage imageWithData:responseData];
                    [[main_view socialMediaView] addNewPost:[item tweet] withUsername:[item username] avatar:profileImage];                    
                }
            }];
        }
        [main_view reloadView];
    }
}



#pragma mark - Date Formatting
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
