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
    BOOL                isUpdated;
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id        timeline;
@property (strong, nonatomic) NSArray   *currentPosts;
@property BOOL isUpdated;


- (id)initWithAccount:(ACAccount *)acc;
- (void)fetchTimeline;
- (void)extractData;


@end
