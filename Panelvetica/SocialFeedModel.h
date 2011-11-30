//
//  SocialFeedModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 22/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface SocialFeedModel : NSObject
{
    ACAccount           *account;    
    id                  timeline;
    NSArray             *currentPosts;
    
    BOOL                finished;
    NSInteger           response;
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id        timeline;
@property (strong, nonatomic) NSArray   *currentPosts;

- (id)initWithAccount:(ACAccount *)acc;
- (void)fetchTimeline;
- (BOOL)isFinished;
- (NSInteger)httpResponse;


@end
