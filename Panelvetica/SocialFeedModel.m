//
//  SocialFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 22/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialFeedModel.h"

@implementation SocialFeedModel 
@synthesize account, timeline, currentPosts;

- (id)initWithAccount:(ACAccount *)acc
{
    if (self = [super init]) {
        self.account = acc;
        finished = NO;
        response = 0;
    }
    return self;
}

- (id)init {
    
    if (self = [super init]) {
        finished = NO;
        response = 0;
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
        }
        
        response = [urlResponse statusCode];
        NSLog(@"Response: %d %@", [urlResponse statusCode], self.account);
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];

    }];
}

- (BOOL)isFinished
{
    return finished;
}

- (NSInteger)httpResponse
{
    return response;
}



 
     
@end
