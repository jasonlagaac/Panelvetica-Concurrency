//
//  SocialFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 22/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialFeedModel.h"
#import "SocialFeedItem.h"

@interface SocialFeedModel (Private)
- (NSComparisonResult) compareItems:(SocialFeedItem *)item;
@end

@implementation SocialFeedModel 
@synthesize account, timeline, currentPosts, isUpdated;

- (id)initWithAccount:(ACAccount *)acc
{
    if (self = [super init]) {
        self.account = acc;
        self.isUpdated = NO;
        NSLog(@"%@",account);
    }
    return self;
}

#pragma mark - Social Feed Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fetchTimeline
{    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"] 
                                                 parameters:nil 
                                              requestMethod:TWRequestMethodGET];
    [postRequest setAccount:self.account]; 
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            self.timeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            dispatch_sync(dispatch_get_main_queue(), ^{            
                [self extractData];
                NSLog(@"updated: %d", self.isUpdated);
            });
        }
    }];
    
}

-(void)extractData {
    NSArray *timelinePosts = [self.timeline subarrayWithRange:NSMakeRange(0, 4)];   
    NSMutableArray *recentPosts = [[NSMutableArray alloc] init];
    
    for (id item in timelinePosts) {        
        NSString *username = [item valueForKeyPath:@"user.screen_name"];
        NSString *post = [item objectForKey:@"text"];
        NSString *created_at = [item objectForKey:@"created_at"];
        
        NSURL *profileImageURL = [NSURL URLWithString:[item valueForKeyPath:@"user.profile_image_url"]];
        
        SocialFeedItem *newItem = [[SocialFeedItem alloc] initWithUsername:username 
                                                                     tweet:post
                                                                profileImg:profileImageURL
                                                                   created:created_at];
        [recentPosts addObject:newItem];
    }
    
    
    
    BOOL compareUsername = [[[recentPosts objectAtIndex:0] username] isEqualToString:[[currentPosts objectAtIndex:0] username]];
    BOOL comparePost = [[[recentPosts objectAtIndex:0] tweet] isEqualToString:[[currentPosts objectAtIndex:0] tweet]];
    
    if (compareUsername && comparePost) {
        self.isUpdated = NO;
    } else {
        self.currentPosts = [recentPosts copy];
        self.isUpdated = YES;
    }
}
 
     
@end
