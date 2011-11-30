//
//  NewsFeedViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeedView;
@class NewsFeedModel;

@interface NewsFeedViewController : UIViewController
{
    NewsFeedView    *newsFeedView;
    NewsFeedModel   *newsFeed;
    
    NSMutableArray  *currentNewsFeed;
}

@property (nonatomic, strong) NewsFeedView  *newsFeedView;
@property (nonatomic, strong) NewsFeedModel *newsFeed;

- (id)initWithRSSFeed:(NSString *)rss;
- (void)newsFeedUpdate;


@end
