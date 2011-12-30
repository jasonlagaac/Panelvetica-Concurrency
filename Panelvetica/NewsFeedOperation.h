//
//  NewsFeedOperation.h
//  Panelvetica
//
//  Created by Jason Lagaac on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomOperation.h"

@class NewsFeedModel;

@interface NewsFeedOperation : CustomOperation
{
    NewsFeedModel *newsFeed;
}

- (id)initWithNewsFeed:(NewsFeedModel *)nfm;

@end
