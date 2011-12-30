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
- (BOOL)compareFeedPost:(id)obj1 
                   with:(id)obj2;
- (BOOL)isNewPostsInFeed:(NSArray *)newPosts;

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
    } else if ([self isNewPostsInFeed:[newsFeed items]]) { 
        int currentTopPos = 0;
        while (currentTopPos < 4) {
            if ([self compareFeedPost:[[newsFeed items] objectAtIndex:0] 
                                 with:[currentNewsFeed objectAtIndex:currentTopPos]]) {
                break;
            }
            currentTopPos++;
        }
        
        if (currentTopPos == 4) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadFeed];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (int i = 0; i < currentTopPos; i++){
                    id item = [[newsFeed items] objectAtIndex:i];
                    
                    NSDictionary *titleElement = [item objectForKey:@"title"];
                    NSDictionary *descriptionElement = [item objectForKey:@"description"];
                    NSDictionary *linkElement = [item objectForKey:@"link"];
                    
                    [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                             heading:[titleElement objectForKey:@"___Entity_Value___"]
                                                link:[linkElement objectForKey:@"___Entity_Value___"]];
                }
            });
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self newsFeedView] hideStatusDisplay];
    });
}

- (void)reloadFeed
{
    for (NSDictionary *item in [newsFeed items]) {
        NSDictionary *titleElement = [item objectForKey:@"title"];
        NSDictionary *descriptionElement = [item objectForKey:@"description"];
        NSDictionary *linkElement = [item objectForKey:@"link"];

        [[self newsFeedView] addNewEntry:[descriptionElement objectForKey:@"___Entity_Value___"]
                                 heading:[titleElement objectForKey:@"___Entity_Value___"]
                                    link:[linkElement objectForKey:@"___Entity_Value___"]];
        
    }
}

#pragma mark - Feed comparison operators
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isNewPostsInFeed:(NSArray *)newPosts
{
    for (int i = 0; i < 4; i++) {
        
        NSString *obj1Description = [[[newPosts objectAtIndex:i] objectForKey:@"description"] objectForKey:@"___Entity_Value___"];
        NSString *obj2Description = [[[currentNewsFeed objectAtIndex:i] objectForKey:@"description"] objectForKey:@"___Entity_Value___"];
        
        if ([obj1Description isEqual:obj2Description]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)compareFeedPost:(id)obj1 
                   with:(id)obj2
{
    TTStyledText *obj1Description = [[obj1 objectForKey:@"description"] objectForKey:@"___Entity_Value___"];
    TTStyledText *obj2Description = [[obj2 objectForKey:@"description"] objectForKey:@"___Entity_Value___"];
    
    if ([obj1Description isEqual:obj2Description]) {
        return YES;
    }
    
    return NO;
}

@end
