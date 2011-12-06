//
//  ScheduleFeedOperation.h
//  Panelvetica
//
//  Created by Jason Lagaac on 5/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomOperation.h"

@class ScheduleFeedModel;

@interface ScheduleFeedOperation : CustomOperation
{
    ScheduleFeedModel   *scheduleFeed;
}

- (id)initWithScheduleFeed:(ScheduleFeedModel *)sfm;

@end
