//
//  SocialFeedItem.m
//  Panelvetica
//
//  Created by Jason Lagaac on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialFeedItem.h"


@interface SocialFeedItem (private)
+(NSDate*)convertTwitterDateToNSDate:(NSString*)created_at;
@end

@implementation SocialFeedItem
@synthesize  username, tweet, profileImageURL, createdAt;

- (id) initWithUsername:(NSString *)usrName 
                  tweet:(NSString *)newPost 
             profileImg:(NSURL *)url
                created:(NSString *)created
{
    self = [super init];
    
    if (self) {
        self.tweet = newPost;
        self.username = usrName;
        self.profileImageURL = url;
        self.createdAt = [SocialFeedItem convertTwitterDateToNSDate:created];
    }
    
    return self;
}

+(NSDate*)convertTwitterDateToNSDate:(NSString*)created_at
{
    // Sat, 11 Dec 2010 01:35:52 +0000
    static NSDateFormatter* df = nil;
    
    df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterFullStyle];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate* convertedDate = [df dateFromString:created_at]; 
    
    return convertedDate;
}

- (NSComparisonResult) compareItems:(SocialFeedItem *)item
{
    return [[self createdAt] compare:[item createdAt]];
}


@end
