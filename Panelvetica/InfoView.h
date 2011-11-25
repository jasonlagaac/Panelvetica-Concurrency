//
//  InfoView.h
//  StatusPad
//
//  Created by Jason Lagaac on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView
{
    CGRect landscapeDimensions;
    CGRect portraitDimensions;
}

- (void)landscapeView;
- (void)portraitView;


@end
