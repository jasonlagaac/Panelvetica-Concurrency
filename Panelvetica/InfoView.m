//
//  InfoView.m
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"

@interface InfoView (PrivateMethods)
- (void)landscapeFrames;
- (void)portraitFrames;
@end

@implementation InfoView

# pragma mark -
# pragma mark Orientation Actions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)landscapeView
{
    [self setFrame:landscapeDimensions];
    [self landscapeFrames];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)portraitView
{
    [self setFrame:portraitDimensions];
    [self portraitFrames];
}

@end
