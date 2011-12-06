//
//  NewsFeedModel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 16/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

#define TOTAL_NEW_POSTS 4

@interface NewsFeedModel : TTURLRequestModel
{
    NSString               *rssFeed;
    NSArray                *items;
    
    BOOL                   finished;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *rssFeed;

- (id)initWithRSSFeed:(NSString*)rssFeed;
- (BOOL)isFinished;

@end
