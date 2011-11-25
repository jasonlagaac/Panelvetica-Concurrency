//
//  NewsFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 16/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedModel.h"
#import "extThree20XML/extThree20XML.h"


@implementation NewsFeedModel
@synthesize items;

- (id)initWithRSSFeed:(NSString *)targetRssFeed
{
    if (self = [super init]) {
        rssFeed = [targetRssFeed copy];
    }
    return self;
}

# pragma mark -
# pragma mark News Feed Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading) {
        
        // We create a new Request for the BuildMobile RSS feed
        // requestDidFinishLoad will be called once the request has ended
        TTURLRequest *request = [TTURLRequest requestWithURL:rssFeed delegate:self];
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
        
        // This tells the URLRequest to return an XML Document (RSS)
        TTURLXMLResponse* response = [[TTURLXMLResponse alloc] init];
        response.isRssFeed = YES; // Make sure Items are grouped together
        request.response = response;
        //TT_RELEASE_SAFELY(response);
        
        [request send];
    }
}

// Our Request has finished, time to parse what is stored in our response
- (void)requestDidFinishLoad:(TTURLRequest *)request {    
    NSMutableArray *feedItems = [[NSMutableArray alloc] init];
    
    self.items = nil;
    self.items = [[NSMutableArray alloc] init];
    
    TTURLXMLResponse *response = (TTURLXMLResponse*) request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *feed = response.rootObject;
    TTDASSERT([[feed objectForKey:@"channel"] isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *channel = [feed objectForKey:@"channel"];
    NSObject *channelItems = [channel objectForKey:@"item"];    
    
    if ([channelItems isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray*) channelItems) {
            NSDictionary *pubDate = [item objectForKey:@"pubDate"];
            
            // Format the Recieved String into a Date
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
            NSDate* date = [dateFormatter dateFromString:[pubDate objectForKey:@"___Entity_Value___"]];
            [item setValue:date forKey:@"pubDate"];
            

            [feedItems addObject:item];
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSArray *sortedFeedItems = [feedItems sortedArrayUsingDescriptors:sortDescriptors];
    
    for (int i = 0; i < TOTAL_NEW_POSTS; i++) {
        [items addObject:[sortedFeedItems objectAtIndex:i]];
    }
    
    NSLog(@"News Item count: %@", [items objectAtIndex:1]);
    [super requestDidFinishLoad:request];	
}


@end
