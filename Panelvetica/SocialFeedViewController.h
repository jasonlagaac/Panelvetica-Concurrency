//
//  SocialFeedViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@class SocialMediaView;
@class SocialFeedModel;

@interface SocialFeedViewController : UIViewController
{
    SocialMediaView      *socialFeedView;
    SocialFeedModel      *socialFeed;
    
    NSArray       *currentPosts;
}

@property (nonatomic, strong) SocialMediaView  *socialFeedView;
@property (nonatomic, strong) SocialFeedModel  *socialFeed;

-(void)feedUpdate;

@end
