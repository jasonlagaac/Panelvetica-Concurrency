//
//  NewsFeedModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 16/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedModel.h"
#import "extThree20XML/extThree20XML.h"

@interface NewsFeedModel (Private)
NSComparisonResult compareDate(id item1, id item2, void *context);
@end

@implementation NewsFeedModel
@synthesize items, rssFeed;

- (id)initWithRSSFeed:(NSString *)targetRssFeed
{
    if (self = [super init]) {
        rssFeed = [targetRssFeed copy];
        finished = NO;
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
        
        finished = NO;
    }
}

// Our Request has finished, time to parse what is stored in our response
- (void)requestDidFinishLoad:(TTURLRequest *)request {    
    NSArray *feedItems = nil;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormatter setLocale:enLocale];
    
    TTURLXMLResponse *response = (TTURLXMLResponse*) request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *feed = response.rootObject;
    TTDASSERT([[feed objectForKey:@"channel"] isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *channel = [feed objectForKey:@"channel"];
    NSObject *channelItems = [channel objectForKey:@"item"]; 
    NSArray *unsortedItems = (NSArray*) channelItems;
    
    // Sort the objects by date in chronological order. Fucking RSS feeds don't do that by default. 
    NSSortDescriptor *itemSort = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO comparator:^NSComparisonResult(id item1, id item2){
        NSDate  *objDate1  = [dateFormatter dateFromString:[item1 objectForKey:@"___Entity_Value___"]];
        NSDate  *objDate2 = [dateFormatter dateFromString:[item2 objectForKey:@"___Entity_Value___"]];
        
        return [objDate1 compare:objDate2];
    }];
    
    NSArray *sortDesciptors = [NSArray arrayWithObject:itemSort];
    feedItems = [unsortedItems sortedArrayUsingDescriptors:sortDesciptors];
    items = [[[feedItems subarrayWithRange:NSMakeRange(0, 4)] reverseObjectEnumerator] allObjects];
    
    // Condense the previews to the articles down to 20 words to make it look neater.
    for (id item in items) {
        NSDictionary *description = [item objectForKey:@"description"];
        
        NSString *previewString = [NSString stringWithString:[description objectForKey:@"___Entity_Value___"]];
        NSArray *previewObjects = [previewString componentsSeparatedByString:@" "];
        NSString *previewCondensed = [NSString stringWithString:@""];
        
        if ([previewObjects count] > 18) {
            for (int i = 0; i < 18; i++) {
                
                if (i < 17) 
                    previewCondensed = [previewCondensed stringByAppendingFormat:[NSString stringWithFormat:@"%@ ", [previewObjects objectAtIndex:i]]];
                else 
                    previewCondensed = [previewCondensed stringByAppendingFormat:@"..."];
            }

            [description setValue:[TTStyledText textFromXHTML:previewCondensed]  forKey:@"___Entity_Value___"];
        } else {
            [description  setValue:[TTStyledText textFromXHTML:previewString]  forKey:@"___Entity_Value___"];
        }
    }
    
    [super requestDidFinishLoad:request];	
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished 
{
    return finished;
}


@end
