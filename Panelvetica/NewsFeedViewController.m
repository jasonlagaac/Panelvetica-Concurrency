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
        for (NSDictionary *item in [newsFeed items]) {
            NSDictionary *titleElement = [item objectForKey:@"title"];
            NSDictionary *descriptionElement = [item objectForKey:@"description"];
            
            [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                          heading:[titleElement objectForKey:@"___Entity_Value___"]];
            
        }
    } else if (![currentNewsFeed isEqualToArray:[newsFeed items]]) { 
        NSLog(@"here!!!");
        for (int i = ([[newsFeed items] count] - 1); i >= 0; i--) {
            NSDictionary *item = [[newsFeed items] objectAtIndex: i];
            
            if ([[[currentNewsFeed objectAtIndex:0] objectForKey:@"pubDate"] compare:[item objectForKey:@"pubDate"]] 
                != NSOrderedSame) {
                [currentNewsFeed removeLastObject];
                [currentNewsFeed insertObject:item atIndex:0];
                
                NSDictionary *titleElement = [item objectForKey:@"title"];
                NSDictionary *descriptionElement = [item objectForKey:@"description"];
                
                [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                              heading:[titleElement objectForKey:@"___Entity_Value___"]];
                
            }
        }
    }
}


@end
