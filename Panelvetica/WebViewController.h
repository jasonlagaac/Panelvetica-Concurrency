//
//  WebViewController.h
//  Panelvetica
//
//  Created by Jason Lagaac on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    UIWebView           *webView;
}

- (void)loadPage:(NSURL *)url;

@end


