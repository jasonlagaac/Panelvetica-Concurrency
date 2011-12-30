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

#import "WeatherView.h"
#import "WeatherFeedModel.h"
#import "WeatherViewController.h"
#import "WeatherFeedOperation.h"

#import "SocialFeedViewController.h"
#import "SocialFeedOperation.h"
#import "SocialFeedModel.h"
#import "SocialMediaView.h"

#import "NewsFeedViewController.h"
#import "NewsFeedOperation.h"
#import "NewsFeedModel.h"
#import "NewsFeedView.h"

#import "ScheduleFeedViewController.h"
#import "ScheduleFeedModel.h"
#import "ScheduleFeedOperation.h"
#import "ScheduleView.h"

#import "WebViewController.h"
#import "NavigationController.h"

@interface RootViewController (PrivateMethods)
- (void)setViewLandscape;
- (void)setViewPortrait;

- (void)initFeedOperations;
- (void)runFeedOperations;
- (void)dismissView:(id)sender;
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
        weatherViewController = [[WeatherViewController alloc] init];

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

    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:newsFeedOper]) {
        [newsFeedViewController newsFeedUpdate];
        [object removeObserver:self
                    forKeyPath:@"isFinished"];
        
    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:scheduleFeedOper]) {
        [scheduleFeedViewController feedUpdate];
        [object removeObserver:self
                    forKeyPath:@"isFinished"];
        
    } else if ([keyPath isEqualToString:@"isFinished"] && [object isEqual:weatherFeedOper]) {
        [weatherViewController feedUpdate];
        [object removeObserver:self
                    forKeyPath:@"isFinished"];
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
    [rootView addSubview:[weatherViewController view]];

}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
       
    navigator = [TTNavigator navigator];
    navigator.delegate = self;
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
     
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
    
    [[NSRunLoop currentRunLoop] addTimer:updateTimer 
                                 forMode:NSRunLoopCommonModes];
    
    [[NSRunLoop currentRunLoop] addTimer:dateTimeTimer 
                                 forMode:NSRunLoopCommonModes];
     
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(currentOrientation))
        [self setViewLandscape];
    else
        [self setViewPortrait];
}

#pragma mark - Data Operations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initFeedOperations
{
    // Social Feed Operations
    
    [[socialFeedViewController socialFeedView] setStatusLoading];
    if ([settings accounts] != nil) {
        SocialFeedModel *sm = [socialFeedViewController socialFeed];
        [[socialFeedViewController socialFeed] setAccount:[[settings accounts] objectAtIndex:0]];
        socialFeedOper = [[SocialFeedOperation alloc] initWithSocialFeed:sm];
        [socialFeedOper addObserver:self
                         forKeyPath:@"isFinished" 
                            options:0
                            context:nil];
        [operationQueue addOperation:socialFeedOper];
    }   
    
    // News Feed Operations
    NewsFeedModel *nfm = [newsFeedViewController newsFeed];
    newsFeedOper = [[NewsFeedOperation alloc] initWithNewsFeed:nfm];
    [newsFeedOper addObserver:self
                   forKeyPath:@"isFinished" 
                      options:0 
                      context:nil];
    [[newsFeedViewController newsFeedView] setStatusLoading];
    [operationQueue addOperation:newsFeedOper];
    
    // Weather Feed Operations
    WeatherFeedModel *wfm = [weatherViewController weatherFeed];
    LocationModel *lcm = [weatherViewController location]; 
    weatherFeedOper = [[WeatherFeedOperation alloc] initWithWeatherModel:wfm 
                                                           locationModel:lcm];
    [weatherFeedOper addObserver:self
                      forKeyPath:@"isFinished" 
                         options:0
                         context:nil];
    [[weatherViewController weatherView] setStatusLoading];
    [operationQueue addOperation:weatherFeedOper];
    
    // Social Feed Operations
    ScheduleFeedModel *sfm = [scheduleFeedViewController scheduleFeed];
    scheduleFeedOper = [[ScheduleFeedOperation alloc] initWithScheduleFeed:sfm];
    [scheduleFeedOper addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    [[scheduleFeedViewController scheduleView] setStatusLoading];
    [operationQueue addOperation:scheduleFeedOper];
    
}



#pragma mark - Timer Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)runFeedOperations
{

    // Social Feed Operations
    if (![socialFeedOper isExecuting]) {
        if ([settings accounts] != nil) {
            SocialFeedModel *sm = [socialFeedViewController socialFeed];
            [[socialFeedViewController socialFeed] setAccount:[[settings accounts] objectAtIndex:0]];
            socialFeedOper = [[SocialFeedOperation alloc] initWithSocialFeed:sm];
            [socialFeedOper addObserver:self
                             forKeyPath:@"isFinished" 
                                options:0
                                context:nil];
            [operationQueue addOperation:socialFeedOper];
        }
    }
    
    // Schedule Feed Operation
    if (![scheduleFeedOper isExecuting]) {
        ScheduleFeedModel *sfm = [scheduleFeedViewController scheduleFeed];
        scheduleFeedOper = [[ScheduleFeedOperation alloc] initWithScheduleFeed:sfm];
        [scheduleFeedOper addObserver:self
                         forKeyPath:@"isFinished" 
                            options:0
                            context:nil];
        [operationQueue addOperation:scheduleFeedOper];;

    }
    
    // Weather Feed Operation
    if (![weatherFeedOper isExecuting]) {
        WeatherFeedModel *wfm = [weatherViewController weatherFeed];
        LocationModel *lcm = [weatherViewController location]; 
        weatherFeedOper = [[WeatherFeedOperation alloc] initWithWeatherModel:wfm 
                                                               locationModel:lcm];
        [weatherFeedOper addObserver:self
                          forKeyPath:@"isFinished" 
                             options:0
                             context:nil];
        [operationQueue addOperation:weatherFeedOper];
    }
    
    // News Feed Operation
    if (![newsFeedOper isExecuting]) {
        NewsFeedModel *nfm = [newsFeedViewController newsFeed];
        newsFeedOper = [[NewsFeedOperation alloc] initWithNewsFeed:nfm];
        [newsFeedOper addObserver:self
                       forKeyPath:@"isFinished" 
                          options:0 
                          context:nil];
        [operationQueue addOperation:newsFeedOper];  
 
    }
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
    [[weatherViewController weatherView] landscapeView];
    
    [rootView setLandscape];
}

- (void)setViewPortrait
{
    [[socialFeedViewController socialFeedView] portraitView];
    [[newsFeedViewController newsFeedView] portraitView];
    [[scheduleFeedViewController scheduleView] portraitView];
    [[dateTimeViewController dateTimeView] portraitView];
    [[weatherViewController weatherView] portraitView];

    [rootView setPortrait];
}

#pragma mark - Navigator delegates

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) navigator:(TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)URL {
    // Now you can catch the clicked URL, and can do whatever with it
    // For Example: In my case, I take the query of the URL
    // If no query is available, let the app open the URL in Safari
    // If there's query, get its value and process within the app

    if (URL == nil) {
        return NO;
    } else {
        //Create a URL ob
        webViewController = [[WebViewController alloc]  init];
        [webViewController loadPage:URL];
        navViewController = [[NavigationController alloc] initWithRootViewController:webViewController];
        [[navViewController navigationBar] setTintColor:[UIColor blackColor]];
        
        [self presentModalViewController:navViewController animated:YES];
        
        return YES;
    }
}



@end
