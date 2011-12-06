//
//  RootViewController.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"
#import "SettingsModel.h"

#import "DateTimeViewController.h"
#import "DateAndTimeView.h"

#import "TemperatureView.h"

#import "SocialFeedViewController.h"
#import "SocialFeedOperation.h"
#import "SocialFeedModel.h"
#import "SocialMediaView.h"

#import "NewsFeedViewController.h"
#import "NewsFeedModel.h"
#import "NewsFeedView.h"

#import "ScheduleFeedViewController.h"
#import "ScheduleFeedModel.h"
#import "ScheduleFeedOperation.h"
#import "ScheduleView.h"


@interface RootViewController (PrivateMethods)
- (void)setViewLandscape;
- (void)setViewPortrait;

- (void)initFeedOperations;
- (void)runFeedOperations;
@end


@implementation RootViewController
@synthesize settings;

- (id)init 
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        settings = [[SettingsModel alloc] init];
        
        // View controllers
        socialFeedViewController = [[SocialFeedViewController alloc] init];
        newsFeedViewController = [[NewsFeedViewController alloc] initWithRSSFeed:@"http://rss.cnn.com/rss/edition.rss"];
        scheduleFeedViewController = [[ScheduleFeedViewController alloc] init];
        dateTimeViewController = [[DateTimeViewController alloc] init];
        
        // Concurrency objects
        operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

# pragma mark - Key Value Observation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    NSLog(@"Object: %@  keyPath: %@", object, keyPath);
    if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:socialFeedOper]) {
        [socialFeedViewController feedUpdate];
        [object removeObserver:self
                    forKeyPath:@"isFinished"];

    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:[newsFeedViewController newsFeed]]) {
        [newsFeedViewController newsFeedUpdate];
        
    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:scheduleFeedOper]) {
        [scheduleFeedViewController feedUpdate];
    }
}


#pragma mark - View lifecycle
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
    rootView = [[RootView alloc] init];
    [self setView:rootView];
    
    [rootView addSubview:[socialFeedViewController view]];
    [rootView addSubview:[newsFeedViewController view]];
    [rootView addSubview:[scheduleFeedViewController view]];
    [rootView addSubview:[dateTimeViewController view]];

    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(currentOrientation))
        [self setViewLandscape];
    else
        [self setViewPortrait];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initFeedOperations];
    updateTimer = [NSTimer timerWithTimeInterval:(30.0) 
                                          target:self 
                                        selector:@selector(runFeedOperations) 
                                        userInfo:nil 
                                         repeats:YES];
    
    dateTimeTimer = [NSTimer timerWithTimeInterval:(1.0) 
                                            target:dateTimeViewController 
                                          selector:@selector(dateTimeViewUpdate) 
                                          userInfo:nil 
                                           repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] addTimer:dateTimeTimer forMode:NSRunLoopCommonModes];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {

}

#pragma mark - Data Operations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initFeedOperations
{
    // Social Feed Operations
    SocialFeedModel *sm = [socialFeedViewController socialFeed];
    [[socialFeedViewController socialFeed] setAccount:[[settings accounts] objectAtIndex:0]];
    socialFeedOper = [[SocialFeedOperation alloc] initWithSocialFeed:sm];
    [socialFeedOper addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    [operationQueue addOperation:socialFeedOper];
    
    // Social Feed Operations
    ScheduleFeedModel *sfm = [scheduleFeedViewController scheduleFeed];
    scheduleFeedOper = [[ScheduleFeedOperation alloc] initWithScheduleFeed:sfm];
    [scheduleFeedOper addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    [operationQueue addOperation:scheduleFeedOper];

    
    // News Feed Operations
    NewsFeedModel *nfm = [newsFeedViewController newsFeed];
    [nfm addObserver:self 
          forKeyPath:@"isFinished" 
             options:0 
             context:nil];
    [nfm load:TTURLRequestCachePolicyNone more:NO];
}



#pragma mark - Timer Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)runFeedOperations
{
    NSLog(@"Running");
    // Social Feed Operations
    if (![socialFeedOper isExecuting]) {
        SocialFeedModel *sm = [socialFeedViewController socialFeed];
        socialFeedOper = [[SocialFeedOperation alloc] initWithSocialFeed:sm];
        [socialFeedOper addObserver:self
                         forKeyPath:@"isFinished" 
                            options:0
                            context:nil];
        [operationQueue addOperation:socialFeedOper];
    }
    
    // Schedule Feed Operation
    if (![scheduleFeedOper isExecuting]) {
        ScheduleFeedModel *sfm = [scheduleFeedViewController scheduleFeed];
        scheduleFeedOper = [[ScheduleFeedOperation alloc] initWithScheduleFeed:sfm];
        [scheduleFeedOper addObserver:self
                         forKeyPath:@"isFinished" 
                            options:0
                            context:nil];
        [operationQueue addOperation:scheduleFeedOper];
    }
    
    // News Feed Operation
    if (![[newsFeedViewController newsFeed] isLoading])
        [[newsFeedViewController newsFeed] load:TTURLRequestCachePolicyNone more:NO];
}



#pragma mark - Rotation actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || 
        toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self setViewPortrait];
    } else
        [self setViewLandscape];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)setViewLandscape 
{
    [[socialFeedViewController socialFeedView] landscapeView];
    [[newsFeedViewController newsFeedView] landscapeView];
    [[scheduleFeedViewController scheduleView] landscapeView];
    [[dateTimeViewController dateTimeView] landscapeView];
    
    [rootView setLandscape];
}

- (void)setViewPortrait
{
    [[socialFeedViewController socialFeedView] portraitView];
    [[newsFeedViewController newsFeedView] portraitView];
    [[scheduleFeedViewController scheduleView] portraitView];
    [[dateTimeViewController dateTimeView] portraitView];


    [rootView setPortrait];
}

@end
