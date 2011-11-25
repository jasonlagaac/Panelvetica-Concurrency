//
//  SettingsModel.m
//  Panelvetica
//
//  Created by Jason Lagaac on 22/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsModel.h"

@implementation SettingsModel
@synthesize accounts, accountStore;

- (id)init 
{
    if (self = [super init]) {
        
        ////////////////////////////////
        // Initialise twitter account //
        ////////////////////////////////
        if (accounts == nil) {
            if (accountStore == nil) {
                self.accountStore = [[ACAccountStore alloc] init];
            }
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                    });
                }
            }];
        }
    }
    
    return self;
}
@end
