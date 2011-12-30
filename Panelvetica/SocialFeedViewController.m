//
//  SocialFeedViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialFeedViewController.h"
#import "SocialFeedModel.h"
#import "SocialMediaView.h"

@interface SocialFeedViewController (Private)
- (void)reloadFeed;
- (BOOL)isNewPostsInFeed:(NSArray *)newPosts;
- (BOOL)compareFeedPost:(id)obj1 
                   with:(id)obj2;

@end


@implementation SocialFeedViewController
@synthesize  socialFeedView, socialFeed;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        socialFeed = [[SocialFeedModel alloc] init];
        socialFeedView = [[SocialMediaView alloc] init];
        
        [self setView:socialFeedView];
    }
    
    return self;
}

#pragma mark - Feed operations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)feedUpdate {
    NSArray *recentPosts = [[[self socialFeed]timeline] subarrayWithRange:NSMakeRange(0, 4)];   
    
    if (currentPosts == nil) {
        currentPosts = [[NSArray alloc] initWithArray:[recentPosts copy]];
        [self reloadFeed];
        //NSLog(@"current pos: %@",[currentPosts objectAtIndex:0]);
        
    } else if ([self isNewPostsInFeed:recentPosts]) {
        
        // Determine up to which posts need changing
        int currentTopPos = 0;
        while (currentTopPos < 4) {
            if ([self compareFeedPost:[currentPosts objectAtIndex:0] with:[recentPosts objectAtIndex:currentTopPos]])
                break;
            currentTopPos++;
        }
        
        // If the new post count is equal to the max capacity then reload the feed.
        if (currentTopPos == 4) {
            [self reloadFeed];
        } else {
            // replace the objects which only need replacing so that we dont have to redraw the feed.
            for (int i = 0; i < currentTopPos; i++){
                id item = [recentPosts objectAtIndex:i];
                
                NSString *username = [item valueForKeyPath:@"user.screen_name"];
                NSString *post = [item objectForKey:@"text"];
                
                // Draw the posts in the interface.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self socialFeedView] addNewPost:post 
                                         withUsername:username];
                });
            }
        }
        
        // Assign the new feed to the currentPosts array
        currentPosts = nil;
        currentPosts = [[NSArray alloc] initWithArray:[recentPosts copy]];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (recentPosts != nil)
            [[self socialFeedView] hideStatusDisplay];
    });
}

- (void)reloadFeed 
{    
    for (id item in [[currentPosts reverseObjectEnumerator] allObjects]) {
        NSString *username = [item valueForKeyPath:@"user.screen_name"];
        NSString *post = [item objectForKey:@"text"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self socialFeedView] addNewPost:post 
                                 withUsername:username];
        });
    }
}

#pragma mark - Feed comparison operators
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isNewPostsInFeed:(NSArray *)newPosts
{
    for (int i = 0; i < 4; i++) {
        NSString *newFeedUsername = [[newPosts objectAtIndex:i] valueForKeyPath:@"user.screen_name"];
        NSString *newFeedPost = [[newPosts objectAtIndex:i]valueForKeyPath:@"text"];
        
        NSString *currFeedUsername = [[currentPosts objectAtIndex:i] valueForKeyPath:@"user.screen_name"];
        NSString *currFeedPost = [[currentPosts objectAtIndex:i]valueForKeyPath:@"text"];
        
        if (![currFeedUsername isEqualToString:newFeedUsername] || ![currFeedPost isEqualToString:newFeedPost]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)compareFeedPost:(id)obj1 
                   with:(id)obj2
{
    NSString *obj1Username = [obj1 valueForKeyPath:@"user.screen_name"];
    NSString *obj1Post = [obj1 valueForKeyPath:@"text"];
    
    NSString *obj2Username = [obj2 valueForKeyPath:@"user.screen_name"];
    NSString *obj2Post = [obj2 valueForKeyPath:@"text"];
    
    if ([obj1Username isEqualToString:obj2Username] && [obj1Post isEqualToString:obj2Post]) {
        return YES;
    }
    
    return NO;
}
@end
