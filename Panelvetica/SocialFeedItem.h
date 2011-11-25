//
//  SocialFeedItem.h
//  Panelvetica
//
//  Created by Jason Lagaac on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialFeedItem : NSObject
{
    NSString      *username;
    NSString      *tweet;
    NSURL         *profileImageURL;
    NSDate        *createdAt;
}

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) NSURL    *profileImageURL;
@property (nonatomic, strong) NSDate   *createdAt;



- (id) initWithUsername:(NSString *)usrName 
                  tweet:(NSString *)newPost 
             profileImg:(NSURL *)url
                created:(NSString *)created;

@end
