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
        [socialFeedViewController extractData];
        [object removeObserver:self
                    forKeyPath:@"isFinished"];

    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:[newsFeedViewController newsFeed]]) {
        [newsFeedViewController newsFeedUpdate];
        
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

    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(currentOrientation))
        [self setViewLandscape];
    else
        [self setViewPortrait];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated 
{    
    [self initFeedOperations];
    updateTimer = [NSTimer timerWithTimeInterval:(30.0) 
                                          target:self 
                                        selector:@selector(runFeedOperations) 
                                        userInfo:nil 
                                         repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];


}

#pragma mark - Data Operations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initFeedOperations
{
    SocialFeedModel *sm = [socialFeedViewController socialFeed];
    [[socialFeedViewController socialFeed] setAccount:[[settings accounts] objectAtIndex:0]];
    socialFeedOper = [[SocialFeedOperation alloc] initWithSocialFeed:sm];
    [socialFeedOper addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    [operationQueue addOperation:socialFeedOper];
    
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
    
    [rootView setLandscape];
}

- (void)setViewPortrait
{
    [[socialFeedViewController socialFeedView] portraitView];
    [[newsFeedViewController newsFeedView] portraitView];
    [[scheduleFeedViewController scheduleView] portraitView];

    [rootView setPortrait];
}

@end
