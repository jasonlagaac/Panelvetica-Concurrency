//
//  WebViewController.m
//  Panelvetica
//
//  Created by Jason Lagaac on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController (Private)
- (void)dismissView:(id)sender;
@end


@implementation WebViewController

- (id)init {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        self.view = webView;
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self 
                                                                  action:@selector(dismissView:)];
    [backButton setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    webView.delegate = nil;
    [webView stopLoading];
}

- (void)loadPage:(NSURL *)url {
    //URL Requst Object
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)dismissView:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
