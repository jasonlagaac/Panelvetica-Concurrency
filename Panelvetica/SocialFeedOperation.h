//
//  SocialFeedOperation.h
//  Panelvetica
//
//  Created by Jason Lagaac on 27/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomOperation.h"

@class SocialFeedModel;

@interface SocialFeedOperation : CustomOperation
{
    SocialFeedModel     *socialFeed;
}

- (id)initWithSocialFeed:(SocialFeedModel *)sf;

@end
