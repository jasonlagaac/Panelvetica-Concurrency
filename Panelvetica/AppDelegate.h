//
//  AppDelegate.h
//  StatusPad
//
//  Created by Jason Lagaac on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainView;
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
    MainView *main_view;
    RootViewController *root_controller;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
