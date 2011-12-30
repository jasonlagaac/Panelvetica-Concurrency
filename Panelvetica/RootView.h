//
//  MainView.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIView
{
    UIButton            *settingsButton;
    UIButton            *reloadButton;
    
    UIImageView         *backgroundImage;
    UIView              *opacityLayer;
}

- (void)setPortrait;
- (void)setLandscape;
- (void)reloadView;

@end
