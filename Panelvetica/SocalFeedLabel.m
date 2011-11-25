//
//  SocailFeedLabel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocalFeedLabel.h"

@implementation SocalFeedLabel
@synthesize  status_text, profile_image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        profile_image = [[UIImageView alloc] init];
        [profile_image setFrame:CGRectMake(0, 0, 50, 50)];
        
        status_text = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        [status_text setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        [self addSubview:profile_image];
        [self addSubview:status_text];
    }
    return self;
}

- (void)setFrame:(CGRect)frame 
{
    [super setFrame:frame];
    [status_text setFrame:CGRectMake(60, 0, (frame.size.width - 60), frame.size.height)];
}

# pragma mark -
# pragma mark Label actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPost:(NSString *)text 
   withUsername:(NSString *)user 
         avatar:(UIImage *)avatar 
{
    //NSString *cropped_string = [text substringToIndex: MIN(15, [text length])];
    [profile_image setImage:avatar];
    NSString *post_string = [NSString stringWithFormat:@"<b>%@</b> •  %@", user, text];
    post_string = [post_string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];

    NSLog(@"blah: %@", post_string);
    [status_text setHtml:post_string];
}

@end
