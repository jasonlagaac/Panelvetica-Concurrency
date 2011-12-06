//
//  NewsFeedViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedView.h"
#import "NewsFeedModel.h"

@interface NewsFeedViewController (Private)
- (void)reloadFeed;
@end


@implementation NewsFeedViewController
@synthesize newsFeedView, newsFeed;

- (id)initWithRSSFeed:(NSString *)rss
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        newsFeedView = [[NewsFeedView alloc] init];
        newsFeed = [[NewsFeedModel alloc] initWithRSSFeed:rss];
        currentNewsFeed = [[NSMutableArray alloc] init];
        
        [self setView:newsFeedView];
    }
    
    return self;
}


- (void)newsFeedUpdate
{
    
    if ([currentNewsFeed count] == 0) {
        [currentNewsFeed addObjectsFromArray:[newsFeed items]];
        [self reloadFeed];
    } else if (![currentNewsFeed isEqualToArray:[newsFeed items]]) { 
        int currentTopPos = 0;
        while (currentTopPos < 4) {
            if ([[[newsFeed items] objectAtIndex:0] isEqual:[currentNewsFeed objectAtIndex:currentTopPos]])
                break;
            currentTopPos++;
        }
        
        if (currentTopPos == 4) {
            [self reloadFeed];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                for (int i = 0; i < currentTopPos; i++){
                    id item = [[newsFeed items] objectAtIndex:i];
                    
                    NSDictionary *titleElement = [item objectForKey:@"title"];
                    NSDictionary *descriptionElement = [item objectForKey:@"description"];
                    
                    [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                             heading:[titleElement objectForKey:@"___Entity_Value___"]];
                }
            });
        }
    }
}

- (void)reloadFeed
{
    for (NSDictionary *item in [newsFeed items]) {
        NSDictionary *titleElement = [item objectForKey:@"title"];
        NSDictionary *descriptionElement = [item objectForKey:@"description"];
        
        [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                 heading:[titleElement objectForKey:@"___Entity_Value___"]];
        
    }
}


@end
