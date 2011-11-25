//
//  SocailFeedLabel.h
//  Panelvetica
//
//  Created by Jason Lagaac on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface SocalFeedLabel : UIView
{
    UIImageView *profile_image;
    TTStyledTextLabel *status_text;
}

@property (strong, nonatomic) UIImageView *profile_image;
@property (strong, nonatomic) TTStyledTextLabel *status_text;

- (void)setPost:(NSString *)text 
   withUsername:(NSString *)user 
         avatar:(UIImage *)avatar;
@end
