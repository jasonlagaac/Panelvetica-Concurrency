//
//  NewsFeedView.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedView.h"

@interface NewsFeedView : FeedView

- (void)addNewEntry:(NSString *)content
            heading:(NSString *)heading;
@end
