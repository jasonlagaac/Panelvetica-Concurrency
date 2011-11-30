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

-(void)extractData {
    NSArray *recentPosts = [[[[[self socialFeed]timeline] subarrayWithRange:NSMakeRange(0, 4)] reverseObjectEnumerator] allObjects];   
    
    if (currentPosts == nil) {
        currentPosts = recentPosts;
        [self reloadFeed];

    } else if (![currentPosts isEqualToArray:recentPosts]) {
        int currentTopPos = 0;
        while (currentTopPos < 4) {
            if ([[currentPosts objectAtIndex:0] isEqual:[recentPosts objectAtIndex:currentTopPos]])
                break;
            currentTopPos++;
        }
        
        if (currentTopPos == 4) {
            [self reloadFeed];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                for (int i = 0; i < currentTopPos; i++){
                    id item = [recentPosts objectAtIndex:i];
                    
                    NSString *username = [item valueForKeyPath:@"user.screen_name"];
                    NSString *post = [item objectForKey:@"text"];
                    
                    [[self socialFeedView] addNewPost:post 
                                         withUsername:username];
                }
            });
        }
    }
}

- (void)reloadFeed 
{
    NSArray *recentPosts = [[[[[self socialFeed]timeline] subarrayWithRange:NSMakeRange(0, 4)] reverseObjectEnumerator] allObjects];   
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (id item in recentPosts) {
            NSString *username = [item valueForKeyPath:@"user.screen_name"];
            NSString *post = [item objectForKey:@"text"];
            
            [[self socialFeedView] addNewPost:post 
                                 withUsername:username];
        }
    });
}

@end
